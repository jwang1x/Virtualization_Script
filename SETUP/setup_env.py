import ini_info
import time
import log_save
import setup_vmware_env
import setup_host_env
import setup_linux_env
import setup_windows_env

class Set_OS():

    def __init__(self):
        self.default_ini_name = '../INI/sut.ini'
        self.sut_ini_init = ini_info.Ini_info()
        self.sut_ini_info = self.sut_ini_init.Read_OS_info(self.default_ini_name)



    def main(self):
        date_time = time.strftime('%Y-%m-%d-%H-%m-%S',time.localtime())
        if self.sut_ini_info['os'] == 'linux':
            log_file = f"../LOG/setup_linux_{date_time}"
            self.log = log_save.Log(log_file)
            set_up_l = setup_linux_env.Set_up_l(self.sut_ini_info,self.log)
            set_up_l.main()

        elif self.sut_ini_info['os'] == 'windows':
            log_file = f"../LOG/setup_windows_{date_time}"
            self.log = log_save.Log(log_file)
            set_up_w = setup_windows_env.Set_up_w(self.sut_ini_info,self.log)
            set_up_w.main()

        elif self.sut_ini_info['os'] == 'vmware':
            log_file = f"../LOG/setup_vmware_{date_time}"
            self.log = log_save.Log(log_file)
            set_up_v = setup_vmware_env.Set_up_v(self.sut_ini_info,self.log)
            set_up_v.main()

        elif self.sut_ini_info['os'] == 'host':
            log_file = f"../LOG/setup_vmware_{date_time}"
            self.log = log_save.Log(log_file)
            set_up_v = setup_host_env.Set_up_h(self.sut_ini_info,self.log)
            set_up_v.main()

        else:
            self.log.log_error(f"error not os type {self.sut_ini_info['os']} in [linux,windows,vmware]")
            assert False















if __name__ == "__main__":
    os = Set_OS()
    os.main()
    pass
