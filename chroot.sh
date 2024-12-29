#!/bin/bash

export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true

useradd chromix -m -p ""
usermod -aG sudo chromix
printf "toor\ntoor\n" | passwd

apt install ca-certificates -y

cat > /etc/apt/sources.list << EOF
deb https://deb.debian.org/debian/ bookworm main contrib non-free non-free-firmware
deb-src https://deb.debian.org/debian/ bookworm main contrib non-free non-free-firmware

deb https://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware
deb-src https://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware

deb https://deb.debian.org/debian/ bookworm-updates main contrib non-free non-free-firmware
deb-src https://deb.debian.org/debian/ bookworm-updates main contrib non-free non-free-firmware
EOF

apt update
apt install linux-image-6.1.0-20-amd64 network-manager console-setup console-setup-linux pciutils \
    xserver-xorg-video-all xserver-xorg-input-evdev x11-xserver-utils \
    x11-xkb-utils x11-utils xinit chromium openbox wmctrl neovim git lightdm sudo -y

systemctl enable lightdm
systemctl start lightdm


cat > /etc/resolv.conf << EOF
nameserver 8.8.8.8
nameserver 10.0.2.3

EOF

git clone https://github.com/pablocorbalann/arch-minimal-wallpapers.git

chromium --start-maximized
shutdown -h now

su chromix

mkdir /home/chromix/.config/openbox/autostart
cat > /home/chromix/.config/openbox/autostart << EOF
chrome-shutdown.sh
EOF

cat > /home/chromix/chrome-shutdown.sh << EOF 

chromium --start-maximized
sudo shutdown -h now

EOF

sudo chmod +x /home/chromix/chrome-shutdown.sh 
