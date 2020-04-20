#!/bin/bash

# awk '/^size/ { print $1 " " $3 / 1048576 " MB" }' < /proc/spl/kstat/zfs/arcstats

ARC=$(cat /proc/spl/kstat/zfs/arcstats)

echo "
ARC data
--------------------------------"
awk '/^c /     { print "Target   (c)    : " $3 / 1048576 " MB" }' < /proc/spl/kstat/zfs/arcstats
awk '/^c_min / { print "Min Size (c_min): " $3 / 1048576 " MB" }' < /proc/spl/kstat/zfs/arcstats
awk '/^c_max / { print "MAX Size (C_max): " $3 / 1048576 " MB" }' < /proc/spl/kstat/zfs/arcstats
awk '/^size/   { print "Current  (size) : " $3 / 1048576 " MB" }' < /proc/spl/kstat/zfs/arcstats
