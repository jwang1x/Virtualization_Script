#e.g.:
#python vm_execute.py -p 2222,2223 -u root -w password -c "whoami"
#python vm_execute.py -p 2222,2223 -u root -w password -c "whoami" -m string -l 'ot'


import sys
import argparse
from lnx_exec_with_check import lnx_exec_command
#from constant import *
import time
import paramiko
from resource_config_login import port_gen
import re
import _thread
import threading
from log import logger
from cmd_check_utlis import result_checking

def setup_argparse():
    args = sys.argv[1:]
    parser = argparse.ArgumentParser(
        description='copy file from host to guest vm'
					'--ip <the ip of the vm>'
					'--port <the host port mapping to vm>'
                    '--user<the user name of vm>'
					'--password <the password of vm>'
					'--cmd <the command to be executed>')
    parser.add_argument('-p', '--port', default='', dest='port', action='store', help='the host port list mapping to vm,separated by ,')
    parser.add_argument('-u', '--user', default='root', dest='user', action='store', help='the user name of vm')
    parser.add_argument('-w', '--password', default='password', dest='password', action='store', help='the password of vm')
    parser.add_argument('-c', '--cmd', required=True, dest='cmd', action='store', help='the cmd to be executed')
    parser.add_argument('-n', '--num', default='', dest='num', action='store', help='the number of port to launch if port not specified by -p')
    parser.add_argument('-i', '--ignore_err', default='False', dest='ignore_err', action='store', help='ignore the error of execution in vm')
    parser.add_argument('-m', '--mode', default=None, dest='mode', action='store', help='mode for checking')
    parser.add_argument('-l', '--list', default=None, dest='list', action='store', help='checking string')
    ret = parser.parse_args(args)
    return ret

def remote_exec_cmd(remote_port, remote_un, remote_pwd, cmd, remote_ip, ignore_err='False', chk_mode=None, chk_list=None):
    """
    Function to execute the cmd in remote machine and returns the output
    :param remote_ip: IP of the Remote machine
    :type remote_ip: string
    :param remote_port: User port of Jump Host(Test Pilot)
    :type remote_port: string
    :param remote_pwd: Password of the Jump Host
    :type remote_pwd: String
    :param cmd: cmd to be executed on the remote machine
    :type: cmd: String
    :return: Output of the executed string
    :rtype:str if the cmd prints the output, else returns -1
    """
    try:
        remote_obj = paramiko.SSHClient()
        remote_obj.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        remote_obj.connect(remote_ip, remote_port,username=remote_un, password=remote_pwd)
        stdin, stdout, stderr = remote_obj.exec_command(cmd)
        out = stdout.read().decode('UTF-8')
        err = stderr.read().decode('UTF-8')
        ret = stdout.channel.recv_exit_status()

        logger.info(f'Exec remote cmd "{cmd}" to {remote_ip}:{remote_port}: stdout:\n' + out)
        logger.error(f'Exec remote cmd "{cmd}" to {remote_ip}:{remote_port}: stderr:\n' + err)

        if 0 != ret:
            if 'False' == ignore_err:
                return -1
            else:
                return 0

        if 0 != result_checking(out, chk_mode, chk_list):
            logger.error(f'Exec remote cmd "{cmd}" to {remote_ip}:{remote_port}: check failed!!!')
            if 'False' == ignore_err:
                return -1
            else:
                return 0

        logger.info(f'Exec remote cmd "{cmd}" to {remote_ip}:{remote_port}: check succeeded.')
        return 0
    except Exception as e:
        logger.error(f'Exec remote cmd "{cmd}" to {remote_ip}:{remote_port}: exception: {e}')
        if 'False' == ignore_err:
            return -1
        else:
            return 0


class TaskThread(threading.Thread):

    def __init__(self, func, args=()):
        super(TaskThread, self).__init__()
        self.func = func
        self.args = args
        self.result = -1

    def run(self):
        self.result = self.func(*self.args)

    def get_result(self):
            return self.result

def vm_exec_cmd_parallel(remote_portlist_str, remote_portnum, remote_un, remote_pwd, cmd, ignore_err='False', chk_mode=None, chk_list=None, remote_ip='localhost'):
    """
    Function to execute the cmd in remote machine and returns the output
    :param remote_portlist: User port list of Jump Host(Test Pilot)
    :type remote_portlist: string
    :param remote_pwd: Password of the Jump Host
    :type remote_pwd: String
    :param cmd: cmd to be executed on the remote machine
    :type: cmd: String
    :return: Output of the executed string
    :rtype:str if the cmd prints the output, else returns -1
    """
    logger.info(f'Exec remote cmd "{cmd}" to {remote_ip}:{remote_portlist_str}: start.')

    if remote_portlist_str != '':
        remote_portlist = remote_portlist_str.strip().split(',')
    else:
        if remote_portnum!= '':
            port_gen(int(remote_portnum),False)
        #_, out, err = lnx_exec_command('cat /home/logs/port.log', timeout=60)
        return_code, out, err = lnx_exec_command('cat /home/logs/port.log', timeout=60)
        if return_code:
            raise Exception(f'Exec remote cmd "{cmd}" to {remote_ip}:{remote_portlist_str}: failed reading sut /home/logs/port.log')
        remote_portlist = out.strip().split('\n')
    ts = []
    for remote_port in remote_portlist:
        t = TaskThread(remote_exec_cmd, args=(remote_port, remote_un, remote_pwd, cmd, remote_ip, ignore_err, chk_mode, chk_list))
        #t = threading.Thread(target=remote_exec_cmd, args=(remote_port, remote_un, remote_pwd, cmd, remote_ip, ignore_err,))
        t.start()
        ts.append(t)

    for t in ts:
        t.join()
        if t.get_result() != 0:
            raise Exception(f'Exec remote cmd "{cmd}" to {remote_ip}:{remote_portlist_str}: failed on port {t.args[0]}')

    logger.info(f'Exec remote cmd "{cmd}" to {remote_ip}:{remote_portlist_str}: succeeded.')

    return
	
if __name__ == '__main__':
    args_parse = setup_argparse()

    try:
        vm_exec_cmd_parallel(args_parse.port, args_parse.num, args_parse.user, args_parse.password, args_parse.cmd, args_parse.ignore_err, args_parse.mode, args_parse.list)
        exit(0)
    except Exception as e:
        logger.error(f'{e}')
        exit(1)