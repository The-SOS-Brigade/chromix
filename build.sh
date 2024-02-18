#!/bin/bash
set -e

drive="./drive"
distro="http://deb.debian.org/debian/"
release="stable"

apt update
apt install debootstrap extlinux fdisk -y

rm -rf ./mnt/
mkdir ./mnt/

truncate -s 4G $drive
printf "n\np\n1\n2048\n\na\nw\n" | fdisk $drive

loopdev=$(losetup -f)
losetup -o2048 $loopdev $drive
mkfs.ext4 $loopdev
mount -t ext4 $loopdev mnt

debootstrap $release ./mnt $distro
cd mnt
mkdir -p boot/extlinux
extlinux -i boot/extlinux

losetup -d $loopdev

echo System ready.
