#!/bin/bash
set -e

dir="./dist"
rm -fr $dir
mkdir -p $dir
drive="${dir}/drive"
base_repo="http://deb.debian.org/debian/"
release="stable"

apt update
apt install debootstrap extlinux fdisk -y

mkdir $dir/mnt/

truncate -s 4G $dir/drive
printf "n\np\n1\n2048\n\na\nw\n" | fdisk $dir/drive

loopdev=$(losetup -f)
losetup -o1048576 $loopdev $drive
mkfs.ext4 $loopdev
mount -t ext4 $loopdev $dir/mnt/

debootstrap $release $dir/mnt $base_repo
mkdir -p $dir/mnt/boot/extlinux
extlinux -i $dir/mnt/boot/extlinux
cp extlinux.conf $dir/mnt/boot/extlinux

mount --make-rslave --rbind /proc $dir/mnt/proc
mount --make-rslave --rbind /sys $dir/mnt/sys
mount --make-rslave --rbind /dev $dir/mnt/dev
mount --make-rslave --rbind /run $dir/mnt/run
cp chroot.sh $dir/mnt
chmod +x $dir/mnt/chroot.sh
chroot $dir/mnt "/chroot.sh"

sync

losetup -d $loopdev

# haruhi mbr btw
dd bs=440 count=1 conv=notrunc if=./mbr.bin of=$drive

echo Done

