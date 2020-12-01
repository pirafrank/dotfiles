#!/usr/bin/env python

import sys
import platform as pl


def get_os_release():
    if pl.system() == "Darwin":
        return pl.mac_ver()[0]  # mac release
    elif pl.system() == "Linux":
        return pl.linux_distribution()  # which linux distro
    elif pl.system() == "Windows":
        return pl.release()  # which windows release


def get_kernel_version():
    if pl.system() == "Darwin":
        return pl.release()
    elif pl.system() == "Linux":
        return pl.release()
    elif pl.system() == "Windows":
        return pl.version()


def get_platform_info():
    return pl.system(), get_os_release(), pl.machine(), get_kernel_version(), sys.version.split(" ")[0], pl.uname()[1]


def print_platform_info():
    print("{} running {} {} on {}, kernel {}, Python {}".format(
        pl.uname()[1], # machine name
        pl.system(),  # which OS
        get_os_release(),  # which OS release
        pl.machine(),  # which architecture is in use
        get_kernel_version(),  # print kernel version
        sys.version.split(" ")[0],  # print python version in use
        ))

if __name__ == '__main__':
    print_platform_info()
