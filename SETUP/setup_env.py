import time

from ini_info import Ini_info
from setup_linux_env import Set_up_l
from setup_v import Set_up_v
from setup_w import  Set_up_w
from log_save import Log


class Set_OS():

    def __init__(self):
        self.default_ini_name = 'sut.ini'
        self.sut_ini_init = Ini_info()
        self.sut_ini_info = self.sut_ini_init.Read_OS_info(self.default_ini_name)



    def main(self):
        date_time = time.strftime('%Y-%m-%d-%H-%m-%S',time.localtime())
        if self.sut_ini_info['os'] == 'linux':
            log_file = f"../LOG/setup_linux_{date_time}"
            self.log = Log(log_file)
            #self.sut_ini_info.update({'log_file':log_file})
            set_up_l = Set_up_l(self.sut_ini_info,self.log)
            set_up_l.main()

        elif self.sut_ini_info['os'] == 'windows':
            log_file = f"../LOG/setup_windows_{date_time}"
            self.log = Log(log_file)

            set_up_w = Set_up_w(self.sut_ini_info,self.log)
            set_up_w.main()

        elif self.sut_ini_info['os'] == 'vmware':
            log_file = f"../LOG/setup_vmware_{date_time}"
            self.log = Log(log_file)
            set_up_v = Set_up_v(self.sut_ini_info,self.log)
            set_up_v.main()

        else:
            self.log.log_error(f"error not os type {self.sut_ini_info['os']} in [linux,windows,vmware]")
            assert False















if __name__ == "__main__":
    os = Set_OS()
    os.main()
    pass
