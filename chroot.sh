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
    x11-xkb-utils x11-utils xinit chromium twm wmctrl netctl dhcpd neovim -y

cat > ~/.xinitrc << EOF
#!/bin/bash
twm &
chromium --no-sandbox
EOF

chown root:root .Xauthority 

cat > ~/.twmrc << EOF

############################################################################
# Font Section
############################################################################
#ResizeFont "*new century schoolbook-medium-i-*--24-*-iso8859-*"
IconManagerFont "-*-terminusv-medium-*-condensed-*-12-*-*-*-*-*-*-*"
MenuFont    "-*-terminusv-bold-*-condensed-*-12-*-*-*-*-*-*-*"
TitleFont   "-*-terminusv-bold-*-condensed-*-12-*-*-*-*-*-*-*"
IconFont    "-*-terminusv-bold-*-condensed-*-12-*-*-*-*-*-*-*"
# font: dt.iki.fi/terminusv

############################################################################
# Variables Section
############################################################################
#
# TWM Boolean Variables
#
AutoRelativeResize  # Allow resize from any point within the window
#ClientBorderWidth  # Take border width from initial border width of window
DecorateTransients  # Transient windows should have titlebars
DontMoveOff     # Do not allow windows to be moved of the screen
ForceIcons      # Force use of "Icons" list instead of client-supplied one
NoBackingStore  # Backing store for twm's menus
NoCaseSensitive     # For sorting icon names in icon manager
NoDefaults      # Needed when building own title buttons and bindings
NoGrabServer        # When popping up menus or moving opaque windows
NoMenuShadows       # Don't draw drop shadows behind menus
#NoRaiseOnMove      # Don't automatically raise when windows are moved
#NoRaiseOnResize        # Don't automatically raise when windows are resized
# NoRaiseOnWarp     # Don't automatically raise window when f.warpto
# NoSaveUnders      # Repaint instead of save-under for menu selection
#NoTitleFocus       # Don't set input focus when window is entered
OpaqueMove      # F.move window instead of just an outline
RandomPlacement     # Don't give ouline-drag for no-geometry windows
RestartPreviousState    # 'Remember' previous state when window manager is restarted
ShowIconManager     # Show icon manager on startup
SortIconManager     # Sort icons alphabetically in iconmanager
WarpUnmapped        # Allow f.warpto to de-iconify windows

#
# TWM Numeric Variables
#
MenuBorderWidth     1
BorderWidth     2   # Frame border width in pixels
ButtonIndent        0   # 0, Title button indentation in pixels
ConstrainedMoveTime 400 # Time (msec) in which double click allows only move in hor or vert direction
FramePadding        2   # Pixelwidth between titlebar decorations and the window frame
IconBorderWidth     2   # Border of icons in pixels
MoveDelta       3   # Number of pixels to move before f.move starts working (also f.deltastop)
TitleButtonBorderWidth  1   # 0, Distance between title buttons
TitlePadding        8   # 16, Distance between title buttons, text and highlight area

#
# TWM String Variables
#
# Path to look for bitmaps if they cannot be found in "bitmapFilePath" resource
IconDirectory       "/usr/include/X11/bitmaps"
IconDirectory       "~/.config/twm/icons"
UsePPosition        "on"        # program requested location, "on" "off" "nonzero"


# TWM Complex Variables
#
IconManagerGeometry "=160x10-0+0" 1
# Define regions to put icons (multiple lines allowed)
# IconRegion    geomstring  # define geometry)
#       vgrav       # North or South fill direction
#       hgrav       # East for West fill direction
#       gridwidth   # grid dimensions to put icons in
#       gridheight
IconRegion      "=300x300+200-0" North East 30 30

Color
{
#DefaultBackground "#222222"
#DefaultForeground "#bbbbbb"
TitleBackground "#222222"
TitleForeground "#bbbbbb"
MenuBackground "#222222"
MenuForeground "#bbbbbb"
MenuBorderColor "#666666"
MenuTitleBackground "#bbbbbb"
MenuTitleForeground "#222222"
BorderColor "#005577"
IconBackground "#222222"
IconForeground "#999999"
IconBorderColor "#999999"
IconManagerBackground "#222222"
IconManagerForeground "#bbbbbb"
IconManagerHighlight "#005577"
BorderTileBackground "#666666"
BorderTileForeground "#666666"
}

Cursors {
# cursorname    "string" for names in include/X11/cursorfont.h
# cursorname    "image" "mask" for cursors taken from bitmap files
Frame       "top_left_arrow"    # "spider"
Title       "top_left_arrow"
Icon        "top_left_arrow"
IconMgr     "top_left_arrow"
Move        "fleur"
Resize      "fleur"
Menu        "sb_left_arrow"
Button      "hand2"
Wait        "watch"
Select      "dot"
Destroy     "pirate"
}

DontIconifyByUnmapping {
    "Xjewel"
}
IconifyByUnMapping

IconManagerDontShow {
#   "names of things which you don't want to see in the icon manager"
    "oclock"
    "xcpustate"
    "xdaliclock"
    "Xman"
    "xmeter"
    "xpbiff"
    "TWM Icon Manager"
    "xload"
    "xeyes"
    "xclock"
}

IconManagers {          # Definition of iconmanagers...
# "winname" ["iconname"]    "geometry"  columns
# "XTerm"           "=300x5+800+5"  5
}

#ForceIcons
Icons {
#   "name"  "name.icon"
    "xterm" "terminal"
    "URxvt" "terminal"
}

NoHighlight {
"TWM Icon Manager"
}

NoStackMode { }     # ignore stacking request for these windows

# MakeTitle { } # Create title bars even when NoTitle has been specified
NoTitle {
#   "names of things for which you don't want a title bar"
    "oclock"
    "swissclock"
    "swisswatch"
    "TWM Icon Manager"
    "xcb"
    "xcmap"
    "xcpustate"
    "xdaliclock"
    "xeyes"
    "Xman"
    "xmeter"
    "xpbiff"
    "xpostit"
    "xload"
    "xclock"
}

#~ NoTitleHighlight # don't highlight titlebar when focused in window
Pixmaps {
# TitleHighlight    "hlines2"
TitleHighlight  "dimple3" # better than notitlehighlight
}

StartIconified  {
#    "console"
}

WarpCursor {        # warp cursor in window when de-iconified
#    "xterm"
}

WindowRing {        # windows to cycle through by f.warpring
#    "xterm"
}

######################################################################
# FUNCTIONS
######################################################################
Function "dmenu_run_hist" {
f.exec "exec dmenu_run_hist -fn 'terminusv:style=bold' -nb '#222222' \
        -nf '#bbbbbb' -sb '#005577' -sf '#dddddd' "
}

Function "pacmenu" {
f.exec "exec pacmenu -l 'dmenu -fn 'terminus:size=9' -nb '#222222' \
        -nf '#bbbbbb' -sb '#005577' -sf '#dddddd' -l 33' "
}

######################################################################
# Titlebuttons
######################################################################
# bitmaps are stored in /usr/include/X11/bitmaps
# ":bitmap" uses internal bitmap
#         (:dot, :xlogo, :iconify, :resize, :question, :delete, :menu)
#---------------------------------------------------------------------
RightTitleButton    "minimize2" = f.iconify
# RightTitleButton  ":menu"     = f.menu "WindowSettings"
RightTitleButton    ":resize"   = f.resize
RightTitlebutton    "close2"    = f.delete

#Button = KEYS : CONTEXT : FUNCTION
#----------------------------------
Button1 =      : root   : f.menu "rootmenu"
Button3 =      : root   : f.menu "TwmWindows"
Button2 =      : root   : f.menu "othermenu"

Button2 =      : window|title  : f.raiselower
Button1 =      : title  : f.move
Button3 =      : title  : f.menu "titlemenu"

Button2 =      : frame  : f.raiselower
Button1 =      : frame  : f.move
Button3 =      : frame  : f.menu "rootmenu"

Button2 =      : iconmgr  : f.delete
Button1 =      : iconmgr  : f.iconify
Button3 =      : iconmgr  : f.iconify

"Tab"   = m | s : all           : f.backiconmgr
"Tab"   = m     : all           : f.forwiconmgr
"Tab"   = m | s : all           : f.upiconmgr
"Tab"   = m     : all           : f.downiconmgr

"Return" = s : all : f.function "dmenu_run_hist"
"Return" = s | c : all : f.function "pacmenu"
"F4" = m : all : f.destroy
"q" = m4 : all : f.destroy
"d" = m : all : f.function "dmenu_run_hist"
"r" = c | m : all : f.restart
"q" = s | m4 : all : f.quit
"t" = m4 : all : f.exec "exec my term"

#
# And a menu with the usual things
#
menu "rootmenu"
{
"Twm"   f.title
"Show Iconmgr"  f.showiconmgr
"Hide Iconmgr"  f.hideiconmgr
}

EOF

cat > ~/.bashrc << EOF
#!/bin/bash
startx

chmod +x ~/.xinitrc
chmod +x ~/.mwmrc
chmod +x ~/.bashrc

EOF

cat > /etc/resolv.conf << EOF
nameserver 8.8.8.8
nameserver 10.0.2.3

EOF
