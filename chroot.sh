#!/bin/bash

export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true

useradd -s /bin/bash chromix -m -p "" 
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
    x11-xkb-utils x11-utils xinit chromium openbox wmctrl neovim git lightdm sudo xdotool tar curl cockpit -y

systemctl enable lightdm
systemctl start lightdm


cat > /etc/resolv.conf << EOF
nameserver 8.8.8.8
nameserver 10.0.2.3

EOF

mkdir -p /home/user-files

curl -L -o /home/user-files/gotty_linux_amd64.tar.gz https://github.com/yudai/gotty/releases/download/v1.0.1/gotty_linux_amd64.tar.gz

tar -xvf /home/user-files/gotty_linux_amd64.tar.gz

sudo cat > /etc/xdg/openbox/autostart << EOF
bash /home/user-files/chrome-shutdown.sh
EOF


cat > /home/user-files/chrome-shutdown.sh << EOF 
bash /home/user-files/chrome-sleep.sh
sudo shutdown -h now

EOF

cat > /home/user-files/chrome-sleep.sh << EOF

#!/bin/bash
chromium --start-maximized &
/gotty --permit-write --port 9000 bash &
 
sleep 40 

#!/bin/bash

# Get the Chromium window ID
WINDOW_ID=\$(xdotool search --onlyvisible --class chromium | head -n 1)

if [ -z "\$WINDOW_ID" ]; then
    echo "Chromium not found!"
    exit 1
fi

echo "Monitoring Chromium window: \$WINDOW_ID"

while true; do
    # Check if the window still exists
    if ! xdotool search --class chromium | grep -q "\$WINDOW_ID"; then
        echo "Chromium window closed. Exiting..."
        exit 0
    fi

    # Get the current window state
    STATE=\$(xprop -id "\$WINDOW_ID" _NET_WM_STATE 2>/dev/null)

    if echo "\$STATE" | grep -q "_NET_WM_STATE_HIDDEN"; then
        echo "Window minimized. Putting the system to sleep..."
        systemctl suspend
        exit 0
    fi

    sleep 1
done
EOF

cat > /home/user-files/chrome-bookmarks.sh << EOF

#!/bin/bash

BOOKMARKS_FILE="/home/chromix/.config/chromium/Default/Bookmarks"

# The bookmark data to add (in JSON format)
NEW_BOOKMARK='{
  "date_added": "16385394680000000",
  "id": "1001",
  "name": "Terminal",
  "type": "url",
  "url": "localhost:9000"
}'

# Append the new bookmark before the closing bracket of the "bookmark_bar" object
sed -i '/"bookmark_bar": {/a \\
  '"\$NEW_BOOKMARK" \\
' "\$BOOKMARKS_FILE"

EOF

chmod +x /home/user-files/chrome-shutdown.sh
chmod +x /home/user-files/chrome-sleep.sh
