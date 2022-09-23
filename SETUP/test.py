import os
import re
import sys
import time
import paramiko
import ssh_client






if __name__ == '__main__':
    uploader = ssh_client.Ssh()
    uploader.upload({'ip':'10.89.92.2','port':22,'user':'root','password':'password','local_dir':'../FILES/linux/','remote_dir':'/root/upload_test/','path_pattern_exluded_tuple':('/.git/', '/.idea/',),'file_suffix_tuple_exluded':'(\'.pyc\', \'.log\', \'.gz\')','only_upload_within_the_last_modify_time':3650 * 24 * 60 * 60,'file_volume_limit':1000 * 1000})
