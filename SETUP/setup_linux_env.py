import ini_info
import client
import copy
import time
import re

class Set_up_l():

    def __init__(self,config,log):
        self.info = ini_info.Ini_info()
        self.ssh = client.Ssh()
        linux_ini = '../INI/linux.ini'
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
                source = ' '

                for key in self.sut_env_info[section].keys():

                    if 'timeout' in key:
                        timeout = self.sut_env_info[section][key]
                        continue

                    if 'proxy' in key:
                        proxy = self.sut_env_info[section][key]
                        continue


                    if 'source' in key:
                        source = ' -i ' + self.sut_env_info[section][key]
                        continue

                    if key in self.sut_env_default.keys():
                        continue

                    if 'cmd' in key:
                        cmd = proxy + " " + self.sut_env_info[section][key]
                        sut_config_info.update({'cmd': cmd, 'timeout': timeout})

                    elif 'upload' in key:
                        uploader_args = {'path_pattern_exluded_tuple':tuple(self.sut_env_info[section]['path_pattern_exluded_tuple'].split(',')),
                                         'file_suffix_tuple_exluded':tuple(self.sut_env_info[section]['file_suffix_tuple_exluded'].split(',')),
                                         'only_upload_within_the_last_modify_time': int(eval(self.sut_env_info[section]['only_upload_within_the_last_modify_time'])),
                                         'file_volume_limit': int(eval(self.sut_env_info[section]['file_volume_limit']))
                                         }

                        sut_config_info.update({'local_dir': re.split(f',',self.sut_env_info[section][key])[0], 'remote_dir': re.split(',', self.sut_env_info[section][key])[1],'timeout': timeout})
                        sut_config_info.update(uploader_args)
                        self.ssh.to_upload_file(sut_config_info,self.log)
                        continue

                    elif 'pip' in key:
                        cmd = proxy + " " + f"pip install {self.sut_env_info[section][key]} " + source + " --user"
                        sut_config_info.update({'cmd': cmd, 'timeout': timeout})

                    elif 'yuminstall' in key:
                        cmd = proxy + " " + f"yum install {self.sut_env_info[section][key]} -y"
                        sut_config_info.update({'cmd': cmd, 'timeout': timeout})

                    elif 'yumremove' in key:
                        cmd = f"yum remove {self.sut_env_info[section][key]} -y"
                        sut_config_info.update({'cmd': cmd, 'timeout': timeout})

                    self.ssh.to_excute_shell_cmd(sut_config_info, self.log)

            else:
                self.log.log_error(f"error section {section} not in {self.sut_env_sections}")
                assert False



    def main(self):
        self.env_setup()






if __name__ == "__main__":
    main = Set_up_l()
    main.main()

