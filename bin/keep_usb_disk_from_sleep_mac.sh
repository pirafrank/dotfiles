#!/bin/bash

while :
do
	dd if=/dev/random of=/Volumes/QUASAR/pointless_junk bs=10k count=200
	sleep 5
done
