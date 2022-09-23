from ini_info import *
import time
import ssh_client as ssh
import re
import copy


class Set_up_l(Ini_info):

    def __init__(self,config,log):
        super(Set_up_l, self).__init__()
        linux_ini = 'linux.ini'
        self.sut_env_info = self.Read_env_info(linux_ini)
        self.sut_env_sections = self.Get_sections(linux_ini)
        self.sut_env_default = self.Get_defaults(linux_ini)
        self.sut_config_info = config
        self.ssh = ssh.Ssh_client()
        self.log = log


    def env_setup(self):

        for section in  self.sut_env_sections:
            sut_config_info = copy.deepcopy(self.sut_config_info)
            if section in self.sut_env_info.keys():
                timeout = 600
                if 'timeout' in self.sut_env_info[section].keys():
                    timeout = self.sut_env_info[section]['timeout']
                    del self.sut_env_info[section]['timeout']

                proxy = ' '
                if 'proxy' in self.sut_env_info[section].keys():
                    proxy = self.sut_env_info[section]['proxy']
                    del self.sut_env_info[section]['proxy']

                source = ' '
                if 'source' in self.sut_env_info[section].keys():
                    source = ' -i ' + self.sut_env_info[section]['source']
                    del self.sut_env_info[section]['source']


                for key,value in self.sut_env_info[section].items():
                    if key in self.sut_env_default.keys():
                        continue

                    cmd = value
                    if 'sleep' in key:
                        time_count = 0
                        self.log.log_info(f"wait the time {value}")
                        #self.log.log_info(f"wait the time {value}")
                        while time_count < int(value):
                            time.sleep(1)
                            time_count = time_count + 1
                            self.log.log_info(f"waiting time {time_count}s \n")
                        continue

                    if 'upload' in section:
                        sut_config_info.update({'local_path': re.split(f',',cmd)[0], 'server_path': re.split(',', cmd)[1],'timeout': timeout})
                        self.ssh.to_upload_file(sut_config_info,self.log)
                        continue

                    elif 'cmd' in section:
                        cmd = proxy + "" + value
                        sut_config_info.update({'cmd': cmd, 'timeout': timeout})

                    elif 'pip' in section:
                        cmd = f"pip install " + cmd + ' '+ proxy + ' ' + source
                        sut_config_info.update({'cmd': cmd, 'timeout': timeout})

                    elif 'yum_groupinstall' in section:
                        cmd = proxy + " yum groupinstall " + value + " -y"
                        sut_config_info.update({'cmd': cmd, 'timeout': timeout})

                    elif 'yum_install' in section:
                        cmd = proxy + " yum install " + value + " -y"
                        sut_config_info.update({'cmd': cmd, 'timeout': timeout})


                    elif 'yum_remove' in section:
                        cmd = f"yum remove " + value + " -y"
                        sut_config_info.update({'cmd': cmd, 'timeout': timeout})

                    self.ssh.to_excute_shell_cmd(sut_config_info,self.log)

            else:
                self.log.log_error(f"error section {section} not in {self.sut_env_section}")
                assert False



    def main(self):
        self.env_setup()






if __name__ == "__main__":
    main = Set_up_l(Ini_info)
    main.main()

