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
losetup -o1048576 $loopdev $drive
mkfs.ext4 $loopdev
mount -t ext4 $loopdev mnt

debootstrap $release ./mnt $distro
mkdir -p ./mnt/boot/extlinux
extlinux -i ./mnt/boot/extlinux
cp extlinux.conf ./mnt/boot/extlinux

mount --make-rslave --rbind /proc ./mnt/proc
mount --make-rslave --rbind /sys ./mnt/sys
mount --make-rslave --rbind /dev ./mnt/dev
mount --make-rslave --rbind /run ./mnt/run
cp chroot.sh ./mnt
chmod +x ./mnt/chroot.sh
chroot ./mnt "/chroot.sh"

sync

losetup -d $loopdev

# haruhi mbr btw
dd bs=440 count=1 conv=notrunc if=./mbr.bin of=$drive 

echo System ready.
