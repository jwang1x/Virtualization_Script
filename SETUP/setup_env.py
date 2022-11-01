import os.path
import log_save
import ini_info
import client
import copy
import time
import re


class Env_setup():

    def __init__(self):
        default_ini_name = '../INI/sut.ini'
        self.info = ini_info.Ini_info()
        self.sut_config_info = self.info.Read_OS_info(default_ini_name)


        date_time = time.strftime('%Y-%m-%d-%H-%m-%S', time.localtime())
        self.log = log_save.Log(f"../LOG/{self.sut_config_info['domain']}/{self.sut_config_info['os']}/setup_{self.sut_config_info['os']}_{date_time}")

        self.ssh = client.Ssh()
        self.localhost = client.Local_host()

        self.sut_env_info = self.info.Read_env_info(self.sut_config_info['ini'])

    def _args_deal_with(self):

        if 'proxy' in self.sut_config_info.keys():
            proxy = ' --proxy ' + self.sut_config_info['proxy']

        else:
            proxy = ''

        if 'pip_source' in self.sut_config_info.keys():
            pip_source = '-i ' + self.sut_config_info['pip_source']
        else:
            pip_source = ' '

        if 'powershell_path' in self.sut_config_info.keys():
            powershell_path = self.sut_config_info['powershell_path']
        else:
            powershell_path = ' '

        if 'python_path' in self.sut_config_info.keys():
            python_path = self.sut_config_info['python_path']
        else:
            python_path = ' '

        return proxy, pip_source, powershell_path,python_path


    def _update_sut_info(self,keyword):


        if self.sut_env_info['deploy_case_step']['implementation'] == 'True':
            __ini_path = self.sut_env_info['deploy_case_step']['case_ini_path']
            for section_key, section_value in self.sut_env_info['deploy_case_step'].items():

                if '.ini' not in section_key:
                    continue

                if not os.path.exists(f'{__ini_path}/{section_key}'):
                    self.log.log_error(f"not found {__ini_path}/{section_key}")
                    continue


                if self.sut_env_info['deploy_case_step'][section_key] != 'True':
                    continue

                self.log.log_info(f"deploying {section_key}\n")
                self.sut_case_env_info = self.info.Read_env_info(f'{__ini_path}/{section_key}')


                for section_key, section_value in self.sut_case_env_info.items():
                    if 'step' not in section_key:
                        continue
                    self.log.log_info(f"run the section {section_key}")

                    if self.sut_case_env_info[section_key]['implementation'] != 'True':
                        self.log.log_info(f"the section {section_key} no deployment required: skip the {section_key}\n")
                        continue


                    for key, value in section_value.items():
                        ext_info_dict = {}
                        if any([value for key_value in keyword if key_value in key]):
                            if 'timeout' in value:
                                for tmp_list in re.split(r',', value):
                                    if 'timeout' in tmp_list:
                                        ext_info_dict.update({'timeout': int(re.split('=', tmp_list)[1])})
                                    else:
                                        ext_info_dict.update({'command': tmp_list})
                            else:
                                ext_info_dict.update({'command': value})
                            yield (key, ext_info_dict)


    def _command_deal_with(self):
        proxy, pip_source,powershell_path,python_path = self._args_deal_with()
        for exec in self._update_sut_info(['cmd','yuminstall','pip','upload','sleep','powershell']):

            sut_info = copy.deepcopy(self.sut_config_info)
            if 'cmd' in exec[0]:
                sut_info.update(exec[1])

            elif 'yuminstall' in exec[0]:
                tmp_proxy = f"export http_proxy=http://{self.sut_config_info['proxy']}; export https_proxy=http://{self.sut_config_info['proxy']};"
                cmd = tmp_proxy +  f" yum install {exec[1]['command']} -y"
                exec[1].update({'command':cmd})
                sut_info.update(exec[1])

            elif 'pip' in exec[0]:
                cmd = f"{python_path} -m pip install {exec[1]['command']} --upgrade pip " + pip_source + proxy
                exec[1].update({'command': cmd})
                sut_info.update(exec[1])


            elif 'upload' in exec[0]:
                sut_info.update(exec[1])
                sut_info.update({'local_dir': re.split(f',', exec[1]['command'])[0], 'remote_dir': re.split(',', exec[1]['command'])[1]})
                sut_info.update({'upload':True})


            elif 'sleep' in exec[0]:
                sleep_time = int(exec[1]['command'])
                start_count_time = 0
                while start_count_time < sleep_time:
                    time.sleep(1)
                    start_count_time += 1
                    self.log.log_info(f"sleep time {sleep_time}s : {start_count_time}s")

                continue

            elif 'powershell' in exec[0]:
                cmd = f" {powershell_path}  {exec[1]['command']}"
                exec[1].update({'command': cmd})
                sut_info.update(exec[1])

            yield sut_info


    def excute_cmd(self):
        for cmd_args in self._command_deal_with():
            if cmd_args['os'] == 'host':
                self.localhost.to_excute_shell_cmd(cmd_args,self.log)
                pass
            else:
                if 'upload' in cmd_args.keys():
                    self.ssh.to_upload_file(cmd_args,self.log)

                else:
                    self.ssh.to_excute_shell_cmd(cmd_args,self.log)

    def main(self):
        self.excute_cmd()



if __name__ == "__main__":
    env = Env_setup()
    env.main()
