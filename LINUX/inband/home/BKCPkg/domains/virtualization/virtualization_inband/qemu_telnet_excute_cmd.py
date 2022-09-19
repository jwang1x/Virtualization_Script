#example python3 qemu_telne_excute_cmd.py --ip 127.0.0.1 --pt 4444 --cmd help --timewait 5


import logging
import telnetlib
import time
import argparse



class TelnetClient():
    def __init__(self,):
        self.tn = telnetlib.Telnet()

    # This function implements telnet login to the host
    def login_host(self,host_ip,fwd_port):
        try:
            # self.tn = telnetlib.Telnet(host_ip,port=23)
            self.tn.open(host_ip,port=fwd_port)
            return True
        except:
            logging.warning('%s:intelernet connect failed'%host_ip)
            return False



    # This function implements the execution of the passed command and outputs the execution result
    def execute_some_command(self,command,timeout):

        self.tn.write(command.encode('ascii')+b'\n')
        time.sleep(timeout)
        command_result = self.tn.read_very_eager().decode('ascii')
        logging.warning('Excute command：\n%s' % command_result)

    # Exit telnet
    def logout_host(self):
        self.tn.write(b"exit\n")

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description = 'Telnet connect & Excute command !')
    parser.add_argument('--ip', action='store',type=str, dest='ip',default='127.0.0.1',help='Destination IP')
    parser.add_argument('--pt', action='store',type=int, dest='pt',help='Destination Port')
    parser.add_argument('--cmd', action='store',type=str, dest='cmd',help='Excute command')
    parser.add_argument('--timewait', action='store',type=int, default=2, dest='timewait',help='Set the time to wait for command result reading')


    args = parser.parse_args()


    telnet_client = TelnetClient()
    # If the login result returns true, execute the command and exit
    if telnet_client.login_host(args.ip,args.pt):
        telnet_client.execute_some_command(args.cmd,args.timewait)
        telnet_client.logout_host()
