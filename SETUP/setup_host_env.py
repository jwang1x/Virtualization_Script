import ini_info
import client
import copy
import time
import re

class Set_up_h():

    def __init__(self,config,log):
        self.info = ini_info.Ini_info()
        self.connect = client.local_host()
        linux_ini = '../INI/host.ini'
        self.sut_env_info = self.info.Read_env_info(linux_ini)
        self.sut_env_sections = self.info.Get_sections(linux_ini)
        self.sut_env_default = self.info.Get_defaults(linux_ini)
        self.sut_config_info = config
        self.log = log


    def env_setup(self):

        for section in  self.sut_env_sections:
            self.log.log_info(f"run the section {section}")
            sut_config_info = copy.deepcopy(self.sut_config_info)
            if section in self.sut_env_info.keys():
                proxy = ' '
                timeout = 100
                pip_source = ' '
                python = ''
                for key in self.sut_env_info[section].keys():

                    if 'timeout' in key:
                        timeout = self.sut_env_info[section][key]
                        continue

                    if 'proxy' in key:
                        proxy = self.sut_env_info[section][key]
                        continue


                    if 'pip_source' in key:
                        pip_source = ' -i ' + self.sut_env_info[section][key]
                        continue

                    if 'python_link' in key:
                        python = self.sut_env_info[section][key]
                        continue



                    if key in self.sut_env_default.keys():
                        continue

                    if 'cmd' in key:
                        cmd = proxy + " " + self.sut_env_info[section][key]
                        sut_config_info.update({'cmd': cmd, 'timeout': timeout})

                    elif 'pip' in key:
                        cmd = proxy + " " +  python + " -m " + f"pip install --upgrade pip {self.sut_env_info[section][key]} " + f"{pip_source}"
                        sut_config_info.update({'cmd': cmd, 'timeout': timeout})

                    elif 'yuminstall' in key:
                        cmd = proxy + " " + f"yum install {self.sut_env_info[section][key]} -y"
                        sut_config_info.update({'cmd': cmd, 'timeout': timeout})

                    elif 'yumremove' in key:
                        cmd = f"yum remove {self.sut_env_info[section][key]} -y"
                        sut_config_info.update({'cmd': cmd, 'timeout': timeout})

                    self.connect.to_excute_shell_cmd(sut_config_info, self.log)

            else:
                self.log.log_error(f"error section {section} not in {self.sut_env_sections}")
                assert False



    def main(self):
        self.env_setup()






if __name__ == "__main__":
    main = Set_up_l()
    main.main()

