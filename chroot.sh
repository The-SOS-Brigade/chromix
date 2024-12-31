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
    x11-xkb-utils x11-utils xinit chromium openbox wmctrl neovim git lightdm sudo xdotool tar curl -y

systemctl enable lightdm
systemctl start lightdm


cat > /etc/resolv.conf << EOF
nameserver 8.8.8.8
nameserver 10.0.2.3

EOF

git clone https://github.com/pablocorbalann/arch-minimal-wallpapers.git


su chromix

curl -L -o /home/chromix/gotty_linux_amd64.tar.gz https://github.com/yudai/gotty/releases/download/v1.0.1/gotty_linux_amd64.tar.gz

tar -xvf /home/chromix/gotty_linux_amd64.tar.gz


sudo cat > /etc/xdg/openbox/autostart << EOF
bash /home/chromix/chrome-shutdown.sh
bash /home/chromix/gotty --write-permit --port 9000 bash
EOF

cat > /home/chromix/chrome-shutdown.sh << EOF 
bash /home/chromix/chrome-sleep.sh
sudo shutdown -h now

EOF

sudo chmod +x /home/chromix/chrome-shutdown.sh

cat > /home/chromix/chrome-sleep.sh << EOF

#!/bin/bash

chromium --start-maximized

sleep 10

# Get the Chromium window ID
WINDOW_ID=\$(xdotool search --onlyvisible --class chromium | head -n 1)

if [ -z "\$WINDOW_ID" ]; then
    echo "Chromium not found!"
    exit 1
fi

echo "Monitoring Chromium window: \$WINDOW_ID"

while true; do
    # Get the current window state
    STATE=\$(xprop -id "\$WINDOW_ID" _NET_WM_STATE)

    if echo "\$STATE" | grep -q "_NET_WM_STATE_HIDDEN"; then
        echo "Window minimized. Putting the system to sleep..."
        systemctl suspend
        exit
    fi

    sleep 1
done

EOF
makedir -p /home/chromix/.config/chromium/Default/Bookmarks 
cat > /home/chromix/.config/chromium/Default/Bookmarks << EOF

{
   "checksum": "a99703a30470a0bbc90a88abe52547a2",
   "roots": {
      "bookmark_bar": {
         "children": [ {
            "date_added": "13380094980375747",
            "date_last_used": "0",
            "guid": "d237f4f0-f5ad-4e61-92b9-0fe5f4f608ae",
            "id": "9",
            "meta_info": {
               "power_bookmark_meta": ""
            },
            "name": "Terminal",
            "type": "url",
            "url": "http://localhost:9000/"
         } ],
         "date_added": "13380041368295196",
         "date_last_used": "0",
         "date_modified": "13380095002652839",
         "guid": "0bc5d13f-2cba-5d74-951f-3f233fe6c908",
         "id": "1",
         "name": "Bookmarks bar",
         "type": "folder"
      },
      "other": {
         "children": [  ],
         "date_added": "13380041368295377",
         "date_last_used": "0",
         "date_modified": "13380094980375747",
         "guid": "82b081ec-3dd3-529c-8475-ab6c344590dd",
         "id": "2",
         "name": "Other bookmarks",
         "type": "folder"
      },
      "synced": {
         "children": [  ],
         "date_added": "13380041368295487",
         "date_last_used": "0",
         "date_modified": "0",
         "guid": "4cf2e351-0e85-532b-bb37-df045d8f8d0f",
         "id": "3",
         "name": "Mobile bookmarks",
         "type": "folder"
      }
   },
   "version": 1
}

EOF
