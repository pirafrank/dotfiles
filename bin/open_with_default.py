#!/usr/bin/env python

import sys
import subprocess
import os
import platform


def open_with_default(path):
    current_platform = platform.system()
    if current_platform == "Linux":
        subprocess.call(["xdg-open", path])
    elif current_platform == "Windows":
        os.system("start "+path)
    elif current_platform == "Darwin":
        subprocess.call(["open", path])


if __name__ == '__main__':
    open_with_default(sys.argv[1])
