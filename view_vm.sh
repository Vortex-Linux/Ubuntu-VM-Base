#!/usr/bin/expect

spawn ship --vm view arch-vm-base

expect "Do you want a full GUI of the VM(By default the view action will show only a terminal of the VM) ? (y/n):"
send "n\r"

interact

