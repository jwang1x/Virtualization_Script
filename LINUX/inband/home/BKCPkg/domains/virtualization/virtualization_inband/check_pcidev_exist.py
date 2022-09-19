
import sys
import argparse
from lnx_exec_with_check import lnx_exec_command
from cmd_check_utlis import result_checking
from log import logger

def setup_argparse():
    args = sys.argv[1:]
    parser = argparse.ArgumentParser(
        description='Check whether some kind of pci device exists.'
                    '--vendor <vendor id>'
                    '--device <device id>')
    parser.add_argument('-v', '--vendor', required=True, dest='vendorid', action='store', help='vendor id of pci device')
    parser.add_argument('-d', '--device', required=True, dest='deviceid', action='store', help='device id of pci device')
    ret = parser.parse_args(args)
    return ret

def check_pcidev_exist(vendor, device):
    cmd = f'lspci -d {vendor}:{device}'
    return_code, out, err = lnx_exec_command(cmd)
    if return_code:
        raise Exception('check_pcidev_exist: lnx_exec_command failed!!!')

    if '' == out:
        return 0
    else:
        return 1

if __name__ == '__main__':
    args_parse = setup_argparse()

    try:
        if check_pcidev_exist(args_parse.vendorid, args_parse.deviceid):
            sys.exit(0)
        else:
            sys.exit(1)
    except Exception as e:
        logger.error(f'{e}')
        sys.exit(-1)