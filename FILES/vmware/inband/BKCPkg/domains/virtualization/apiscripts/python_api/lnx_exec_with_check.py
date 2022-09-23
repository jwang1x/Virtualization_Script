import subprocess
import sys
from cmd_check_utils import setup_argparse, result_checking

def lnx_exec_command(cmd, cwd=None, timeout=60, is_silent=False):
    print("LNX Execute: " + cmd + "\n", flush=True)
    ret_v = 0
    sub = subprocess.Popen(cmd,
                           shell=True,
                           stdout=subprocess.PIPE,
                           stderr=subprocess.PIPE,
                           encoding='utf-8',
                           cwd=cwd)
    if sub.returncode is not None:
        ret_v = sub.returncode
    outs, errs = sub.communicate()
    if not is_silent:
        print(outs)  # print out to framework
        print(errs)
    return ret_v, outs, errs


if __name__ == '__main__':
    args_parse = setup_argparse()
    return_code, out, err = lnx_exec_command(cmd = args_parse.cmd, cwd = args_parse.dir)
    if return_code:
        sys.exit(return_code)
    else:
        console_output = out
        if args_parse.last_line:
            console_output = console_output.split('\n')
            console_output = list(filter(None, console_output))[-1]
        ret = result_checking(console_output, args_parse.mode, args_parse.list)
        sys.exit(ret)

