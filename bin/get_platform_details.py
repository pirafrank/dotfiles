#!/usr/bin/env python

import sys
import platform as pl


def get_os_release():
    if pl.system() == "Darwin":
        var = pl.mac_ver()[0]  # mac release
    elif pl.system() == "Linux":
        var = pl.linux_distribution()  # which linux distro
    elif pl.system() == "Windows":
        var = pl.release()  # which windows release
    return var


def get_arch():
    if pl.machine() == "x86_64":
        var = 64
    elif pl.machine() == "x86":
        var = 32
    return var


def get_kernel_version():
    if pl.system() == "Darwin":
        var = pl.release()
    elif pl.system() == "Linux":
        var = pl.release()
    elif pl.system() == "Windows":
        var = pl.version()
    return var


def get_platform_info():
    return pl.system(), get_os_release(), get_arch(), get_kernel_version(), sys.version.split(" ")[0], pl.uname()[1]


def print_platform_info():
    print pl.system()  # which OS
    print get_os_release()  # which OS release
    print get_arch()  # which architecture is in use
    print get_kernel_version()  # print kernel version
    print sys.version.split(" ")[0]  # print python version in use
    print pl.uname()[1]  # print computer name

if __name__ == '__main__':
    print_platform_info()
