#!/bin/bash
#
# Script to perform a cryptographic secure erase on all NVME devices on the PPB test kit
#
# This is *not* launched by ansible due to its destructive nature.
for i in {0..23}
do
 echo "=> Working on /dev/nvme$i"
 nvme format /dev/nvme0 -ses 2 -n 1
done
