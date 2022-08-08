import boto3
import time
from more_itertools import one
import fabric
from paramiko.ed25519key import Ed25519Key
import io
from fabric.connection import Connection

import logging

logger = logging.getLogger(__name__)


def get_ec2_client(region):
    return boto3.client("ec2", region_name=region)


class DevDesktopBooter:
    def __init__(self, ec2):
        self.ec2 = ec2


    def wait_for_instance(self, instance_id):
        wait_for = 'instance_status_ok'

        waiter = self.ec2.get_waiter(wait_for)

        logger.info(f"Waiting for {wait_for} for instance {instance_id}")

        waiter.wait(InstanceIds=[instance_id])


    def get_instance_public_ip(self, instance_id):
        result = self.ec2.describe_instances(InstanceIds=[instance_id])

        return one(one(result["Reservations"])["Instances"])["PublicIpAddress"]


    def instiate_personal_dev_desktop(self, instance_type, launch_template_name):
        keypair = self.ec2.create_key_pair(
            KeyName=f'BootstrapKey-{int(time.time())}',
            KeyType='ed25519')

        key_name = keypair["KeyName"]
        key_pair_id = keypair["KeyPairId"]
        private_key_content = keypair["KeyMaterial"]

        logger.info(f"Created key {key_name} with id {key_pair_id}")

        pkey = Ed25519Key.from_private_key(io.StringIO(private_key_content))

        result = self.ec2.run_instances(
            InstanceType=instance_type,
            KeyName=key_name,
            LaunchTemplate={
                'LaunchTemplateName': launch_template_name,
                'Version': '$Default'
            },
            MaxCount=1,
            MinCount=1)

        created_instance = one(result['Instances'])
        instance_id = created_instance['InstanceId']

        logger.info(f"Created EC2 instance with id {instance_id}")

        self.wait_for_instance(instance_id)

        instance_ip = self.get_instance_public_ip(instance_id)

        with Connection(instance_ip, user='ubuntu', connect_kwargs={"pkey": pkey}) as c:
            logger.info("Cloning bootstrap repo")
            c.run('git clone https://github.com/grodtron/bootstrap-dev-desktop.git')
            with c.cd('bootstrap-dev-desktop'):
                logger.info("running bootstrap.sh")
                c.run('./bootstrap.sh')

        return created_instance['InstanceId']

