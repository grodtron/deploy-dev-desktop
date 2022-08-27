from src.deploy import DevDesktopBooter

import botocore.session
from botocore.stub import Stubber, ANY
from fabric.testing.fixtures import connection as fabric_mock_connection

from pytest import fixture

@fixture
def ec2():
    real_ec2 = botocore.session.get_session().create_client('ec2', region_name='eu-west-1')
    return Stubber(real_ec2), real_ec2


def test_happy_path(ec2, fabric_mock_connection):
    ec2_stubber, ec2_client = ec2

    sut = DevDesktopBooter(ec2_client, lambda *args, **kwargs: fabric_mock_connection)

    instance_type = 'Foo.nano'
    instance_id = "foobar_instance"
    launch_template_name = 'MyFooTemplate'
    key_name = "FooKey"

    # First we request to make a keypair
    ec2_stubber.add_response(
        'create_key_pair', {
            "KeyName": key_name,
            "KeyPairId": "my_key_pair_id",
            # This is a dummy key used only in this test
            "KeyMaterial": """-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
QyNTUxOQAAACCZYgx+mfsn/5LgzUIAXvYmA1kN9OG2Lxhlhom96tjyZwAAAKBk1NvkZNTb
5AAAAAtzc2gtZWQyNTUxOQAAACCZYgx+mfsn/5LgzUIAXvYmA1kN9OG2Lxhlhom96tjyZw
AAAEDTbPAcxxsuSTIjVi99gWAmK8a5a2NdfRNNIbnGcRmSYZliDH6Z+yf/kuDNQgBe9iYD
WQ304bYvGGWGib3q2PJnAAAAFmdvcmRvbkBpcC0xNzItMzEtNDUtOTcBAgMEBQYH
-----END OPENSSH PRIVATE KEY-----"""
        }, {
            "KeyType": ANY,
            "KeyName": ANY
        })

    # Then we request to run a new instance, passing
    # in the name of the keypair that was created
    ec2_stubber.add_response(
        'run_instances', {
            'Instances': [
                {'InstanceId': instance_id}
            ]
        }, {
            "InstanceType": instance_type,
            "KeyName": key_name,
            "LaunchTemplate": {
                'LaunchTemplateName': launch_template_name,
                'Version': '$Default'
            },
            "MaxCount": 1,
            "MinCount": 1
        })

    # Finally we wait for an "OK" status for the created
    # instance ID
    ec2_stubber.add_response('describe_instance_status', 
        {
            'InstanceStatuses': [
                {
                    'InstanceStatus': {
                        'Status': 'ok',
                    },
                },
            ]
        }, {
                'InstanceIds': [instance_id]
        })


    ec2_stubber.add_response('describe_instances',
        {
            "Reservations": [{
                "Instances": [{
                    "PublicIpAddress": "12.34.56.78"
                }]
            }]
        }, {
                'InstanceIds': [instance_id]
        })


    ec2_stubber.activate()

    assert sut.instiate_personal_dev_desktop(instance_type, launch_template_name) == instance_id
