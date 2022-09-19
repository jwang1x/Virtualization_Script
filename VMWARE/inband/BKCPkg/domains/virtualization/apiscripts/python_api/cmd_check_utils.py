import traceback
import argparse
import sys
import os

def setup_argparse():
    args = sys.argv[1:]
    parser = argparse.ArgumentParser(
        description='execute command with output checking'
                    '--cmd <command> : command to execute'
                    '--mode <check mode>     : "no_found", "keyword", "string", "kv" "or_keyword"'
                    '--list <checking string>   '
                )
    parser.add_argument('-c', '--cmd', required=True, dest='cmd', action='store', help='command to execute')
    parser.add_argument('-d', '--dir', default=None, dest='dir', action='store', help='dir to execute')
    parser.add_argument('-m', '--mode', default=None, dest='mode', action='store', help='mode for checking')
    parser.add_argument('-l', '--list', default=None, dest='list', action='store', help='checking string')
    parser.add_argument('--last-line', action='store_true',  help='only check last line')
    ret = parser.parse_args(args)
    return ret

LOG_PREFIX="CMD result checking pass: Mode:"


def result_checking(out, mode, input):
    if mode == "no_found":
        key_list = input.split(",")
        for key in key_list:
            if key.strip() in out:
                return -1
        return 0
    elif mode == "string":
        if input.strip() in out:
            print(LOG_PREFIX, mode, input, "\n\n",  flush=True)
            return 0
        else:
            return -1
    elif mode == "kv":
        input_list = input.split(",")
        if len(input_list) == 2:
            key = input_list[0]
            v = input_list[1]
            out_lines = out.splitlines()
            for line in out_lines:
                if key in line and v not in line:
                    return -1
                if key in line:
                    print(LOG_PREFIX, mode, line, "\n\n",  flush=True)
            return 0
        else:
            return -1
    elif mode == "keyword":
        key_list = input.split(",")
        for key in key_list:
            if key.strip() not in out:
                return -1
        return 0
    elif mode == "or_keyword":
        key_list = input.split(",")
        for key in key_list:
            if key.strip() in out:
                return 0
        return -1
    return 0


