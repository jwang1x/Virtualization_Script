from configparser import  ConfigParser


class Ini_info():

    def __init__(self):
        #self.default_ini_name = 'sut.ini'
        self.config = ConfigParser()


    def Read_env_info(self,default_ini_name):
        sut_env_dict = {}
        self.config.read(default_ini_name)
        sut_env = self.config.sections()
        # print(sut_env)
        for section in sut_env:
            options = self.config.items(section)
            tmp_dict ={}
            for opt in options:
                tmp_dict.update({opt[0]:opt[1]})

            sut_env_dict.update({section:tmp_dict})

        return sut_env_dict

    def Get_sections(self,default_ini_name):
        self.config.read(default_ini_name)
        sut_env = self.config.sections()
        return sut_env

    def Get_defaults(self,default_ini_name):
        self.config.read(default_ini_name)
        sut_env = self.config.defaults()
        return sut_env



    def Read_OS_info(self,default_ini_name):
        self.config.read(default_ini_name)
        assert (self.config.has_option("DEFAULT", "os"))
        os = self.config['DEFAULT']['os']

        items = self.config.items(os) + self.config.items('args')

        info_dict = {}
        for dict_trans in items:
            info_dict.update({dict_trans[0]: dict_trans[1]})

        return info_dict








if __name__ == "__main__":
    config = Ini_info()
    #config.Read_info("sut.ini")








