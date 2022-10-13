import paramiko
import subprocess
import os
import re
import time


class Ssh():

    def __init__(self):
        """
        :param host:
        :param port:
        :param user:
        :param password:
        :param local_dir:
        :param remote_dir:
        :param path_pattern_exluded_tuple: 命中了这些正则的直接排除
        :param file_suffix_tuple_exluded: 这些结尾的文件排除
        :param only_upload_within_the_last_modify_time: 仅仅上传最近多少天修改的文件
        :param file_volume_limit: 大于这个体积的不上传，单位b。
        """


   

    def _to_connection(self,kwargs):
        ssh_client = paramiko.SSHClient()
        ssh_client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        ssh_client.connect(kwargs['ip'], int(kwargs['ssh_port']), kwargs['user'], kwargs['password'])
        return  ssh_client

    def _to_close_connection(self,ssh_client):
        ssh_client.close()

    def to_excute_shell_cmd(self,kwargs,log):
        Transformation_decode = lambda x: x.read().decode("UTF-8")
        ssh = self._to_connection(kwargs)
        log.log_info(f"run commnad: {kwargs['command']}")
        _, out, err = ssh.exec_command(command=kwargs['command'], timeout=int(kwargs['timeout']))
        out = Transformation_decode(out)
        err = Transformation_decode(err)
        log.log_info(f"out: {out} \n")
        log.log_info(f"err: {err} \n")
        self._to_close_connection(ssh)
        return out, err



    def _to_upload_connection(self,kwargs):

        local_dir = str(kwargs['local_dir']).replace('\\', '/')
        if not local_dir.endswith('/'):
            local_dir += '/'
        remote_dir = str(kwargs['remote_dir']).replace('\\', '/')
        if not remote_dir.endswith('/'):
            remote_dir += '/'

        t = paramiko.Transport((kwargs['ip'], int(kwargs['ssh_port'])))
        t.connect(username=kwargs['user'], password=kwargs['password'])
        sftp = paramiko.SFTPClient.from_transport(t)
        return sftp

    def _judge_need_filter_a_file(self, kwargs,filename: str):
        ext = filename.split('.')[-1]
        if '.' + ext in kwargs['file_suffix_tuple_exluded']:
            return True


        for path_pattern_exluded in tuple(re.split(r',',kwargs['path_pattern_exluded_tuple'])):
            if re.search(path_pattern_exluded, filename):
                return True
        file_st_mtime = os.stat(filename).st_mtime
        volume = os.path.getsize(filename)
        if time.time() - file_st_mtime > int(eval(kwargs['only_upload_within_the_last_modify_time'])):
            return True
        if volume > int(eval(kwargs['file_volume_limit'])):
            return True
        return False

    def _make_dir(self,sftp,dir, final_dir):
        """
        sftp.mkdir 不能直接越级创建深层级文件夹。
        :param dir:
        :param final_dir:
        :return:
        """
        # print(dir,final_dir)
        try:
            sftp.mkdir(dir)
            if dir != final_dir:
                self._make_dir(sftp,final_dir, final_dir)
        except (FileNotFoundError,):
            parrent_dir = os.path.split(dir)[0]
            self._make_dir(sftp,parrent_dir, final_dir)

    def _sftp_put(self,sftp,file_full_name, remote_full_file_name,log):
        log.log_info(f"cp {file_full_name} to {remote_full_file_name}")
        sftp.put(file_full_name, remote_full_file_name)
        log.log_info(f"cp done\n")

    def to_upload_file(self,kwargs,log):
        sftp = self._to_upload_connection(kwargs)
        sftp.banner_timeout = int(kwargs['timeout'])
        for parent, dirnames, filenames in os.walk(kwargs['local_dir']):
            for filename in filenames:
                file_full_name = os.path.join(parent, filename).replace('\\', '/')
                if not self._judge_need_filter_a_file(kwargs,file_full_name):
                    remote_full_file_name = file_full_name.replace(kwargs['local_dir'],kwargs['remote_dir'])
                    try:
                        self._sftp_put(sftp,file_full_name, remote_full_file_name,log)
                    except (FileNotFoundError,) as e:
                        log.log_warning(f"About {remote_full_file_name} : warning {e}")
                        log.log_info(f"Mkdir {os.path.split(remote_full_file_name)[0]}")
                        self._make_dir(sftp,os.path.split(remote_full_file_name)[0], os.path.split(remote_full_file_name)[0])
                        self._sftp_put(sftp,file_full_name, remote_full_file_name,log)
                else:
                    #log.log_info(f"Documents {file_full_name} meet requirements，not upload\n")
                    pass



class Local_host():

    def __init__(self):
        pass

    def to_excute_shell_cmd(self,kwargs,log):
        log.log_info(f"run commnad: {kwargs['command']}")
        ret = subprocess.run(kwargs['command'],shell=True,stdout=subprocess.PIPE,stderr=subprocess.PIPE,encoding="utf-8",timeout=int(kwargs['timeout']))
        log.log_info(f"out: {ret.stdout} \n")
        log.log_error(f"err: {ret.stderr} \n")
        return ret.stdout, ret.stderr















if __name__ == "__main__":
    pass

