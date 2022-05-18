#!/bin/bash

mv "/home/${USER}/.config/rclone/rclone.conf" "/home/${USER}/.config/rclone/rclone.conf.bkp"
cp -a "/mnt/c/Users/${USER}/.config/rclone/rclone.conf" "/home/${USER}/.config/rclone/rclone.conf"
chmod 600 "/home/${USER}/.config/rclone/rclone.conf"

