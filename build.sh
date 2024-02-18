#!/bin/bash
set -e

dir="./dist/"
rm -fr $dir
mkdir -p $dir
distro="http://deb.debian.org/debian/"
release="stable"

apt update
apt install debootstrap extlinux fdisk -y

mkdir $dir/mnt/

truncate -s 4G $dir/drive
printf "n\np\n1\n2048\n\na\nw\n" | fdisk $dir/drive

loopdev=$(losetup -f)
losetup -o2048 $loopdev $dir/drive
mkfs.ext4 $loopdev
mount -t ext4 $loopdev $dir/mnt/

debootstrap $release $dir/mnt/ $distro
cd $dir/mnt/
mkdir -p $dir/extlinux/
extlinux -i $dir/extlinux/

losetup -d $loopdev

echo done
