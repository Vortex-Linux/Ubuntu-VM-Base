#!/bin/bash

SCRIPT_PATH="$(readlink -f "$0")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
XML_FILE="/tmp/debian-vm-base.xml"

LATEST_IMAGE=$(lynx -dump -listonly -nonumbers https://releases.ubuntu.com | grep [0-9] | tail -n 1 | xargs lynx -dump -listonly -nonumbers | grep iso | grep live | grep -v zsync | grep -v torrent | head -n 1)

echo y | ship --vm delete debian-vm-base 

echo n | ship --vm create debian-vm-base --source "$LATEST_IMAGE"

sed -i '/<\/devices>/i \
  <console type="pty">\
    <target type="virtio"/>\
  </console>' "$XML_FILE"

virsh -c qemu:///system undefine debian-vm-base
virsh -c qemu:///system define "$XML_FILE"

echo "Building of VM Complete.Starting might take a while as it might take a bit of type for the vm to boot up and be ready for usage."
ship --vm start debian-vm-base

./view_vm.sh #You have to manually tell the installer to go back to the shell
./setup.sh
./view_vm.sh
./release.sh
