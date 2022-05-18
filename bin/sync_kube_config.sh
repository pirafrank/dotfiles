#!/bin/bash

mv "/home/${USER}/.kube/config" "/home/${USER}/.kube/config.bkp"
cp -a "/mnt/c/Users/${USER}/.kube/config" "/home/${USER}/.kube/config"
chmod 600 "/home/${USER}/.kube/config"

