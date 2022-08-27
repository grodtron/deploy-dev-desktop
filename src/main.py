from deploy import DevDesktopBooter, get_ec2_client, make_ssh_connection
import argparse
import sys
import os
import logging

def get_opts(args):
    parser = argparse.ArgumentParser()

    parser.add_argument('-t', '--instance-type', help="The EC2 instance type to use")
    parser.add_argument('-r', '--region', default='eu-central-1', help='The AWS Region in which to launch')

    return parser.parse_args(args)


def main():
    logging.basicConfig()
    opts = get_opts(sys.argv[1:])

    booter = DevDesktopBooter(get_ec2_client(opts.region), make_ssh_connection)

    booter.instiate_personal_dev_desktop(opts.instance_type, 'PersonalDevDesktopTemplate')


if __name__ == '__main__':
    main()
