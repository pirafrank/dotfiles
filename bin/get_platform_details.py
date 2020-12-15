#!/usr/bin/env python

import sys
import platform as pl


def get_kernel_version():
    if pl.system() == "Darwin":
        return pl.release()
    elif pl.system() == "Linux":
        return pl.release()
    elif pl.system() == "Windows":
        return pl.version()

def get_platform_info():
    return ("{} running {} on {}, kernel {}, Python {}".format(
        pl.uname()[1], # machine name
        pl.system(),  # which OS
        pl.machine(),  # which architecture is in use
        get_kernel_version(),  # print kernel version
        sys.version.split(" ")[0],  # print python version in use
        ))

if __name__ == '__main__':
    print(get_platform_info())

