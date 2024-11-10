#!/bin/bash 

echo "Shutting down the Ubuntu VM..." 

echo y | ship --vm shutdown ubuntu-vm-base 

echo "Compressing the Ubuntu VM disk image..."

ship --vm compress ubuntu-vm-base 

echo "Copying the Ubuntu VM disk image to generate the release package for 'ubuntu-vm-base'..."

DISK_IMAGE=$(sudo virsh domblklist ubuntu-vm-base | grep .qcow2 | awk '{print $2}')

cp "$DISK_IMAGE" output/ubuntu.qcow2

echo "Splitting the copied disk image into two parts..."

split -b $(( $(stat -c%s "output/ubuntu.qcow2") / 2 )) -d -a 3 "output/ubuntu.qcow2" "output/ubuntu.qcow2."

echo "The release package for 'ubuntu-vm-base' has been generated and split successfully!"
