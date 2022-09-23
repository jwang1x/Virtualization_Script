from init_moudle import *

class Log():

    def __init__(self,kwargs):
        self.terminal_init(kwargs)


    def terminal_init(self,kwargs):
        import  logging
        self.Terminal_Log = logging.getLogger("Terminal_Log")
        self.Terminal_Log.setLevel(logging.INFO)
        fmt = logging.Formatter(fmt="%(asctime)s - %(name)s - %(levelname)-9s - %(filename)-8s : %(lineno)s line - %(message)s", datefmt="%Y/%m/%d %H:%M:%S")
        fh = logging.FileHandler(filename=kwargs, mode='a',encoding='utf-8')
        fh.setFormatter(fmt)
        sh = logging.StreamHandler()
        sh.setFormatter(fmt)
        self.Terminal_Log.addHandler(sh)
        self.Terminal_Log.addHandler(fh)

    def log_info(self,message):
        self.Terminal_Log.info(message)

    def log_warning(self, message):
        self.Terminal_Log.warning(message)

    def log_error(self,message):
        self.Terminal_Log.error(message)
