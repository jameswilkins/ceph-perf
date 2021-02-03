#!/bin/bash
#
# Script to perform a cryptographic secure erase on all NVME devices on the test kit
#
# This is *not* launched by ansible due to its destructive nature.
echo "This script *will* irrevocably erase the contents of /dev/nvme[0-23]"
echo "If you do *NOT* wish this to happen - stop this script now"
sleep 10
read -n 1 -s -r -p "Press any key to continue"
for i in {0..23}
do
 echo "=> Working on /dev/nvme$i"
 nvme format /dev/nvme$i -ses 2 -n 1
done
