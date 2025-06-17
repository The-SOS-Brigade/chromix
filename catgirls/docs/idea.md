# Chromix

Chromix - _Chromium Linux_, is a Debian derivative operating system distribution, with a Web Browser as it's graphical desktop environment.

## Features

- tabs, instead of windows
- reboot + shutdown buttons, instead of minimize + maximize window control buttons
- OAuth federated identity provider login, instead of Desktop user login
- browser updates, instead of OS updates
- [PWAs](https://whatpwacando.today/) and Browser Extensions instead of Desktop Apps
- custom CSS + JS for `file://` pages, instead of a file explorer Desktop app
- `github:xtermjs` (the tty emulator VS Code and Windows Terminal use) + tty-webserver, instead of `/dev/tty`

## Implementation

- Linux + Drivers
- C stdlib
- coreutils + `bash`
- $BROWSER + dependencies + DRM
- `apt` - package manager

installed is one Browser per harddrive parition (Google Chrome: partition 0, Microsoft Edge partition: 1, Chromium (without federated identity provider cloud sync): partition 2),

to enable modern PWAs, we should default opt-in into most unofficial _official_ origin trial flag, web platform features. this is a difficult question in every case, i can take care of it.

From my XP, Debian should be the upstream, not Arch Linux. Althought we might get a lot more users with Arch Linux. I dont want to ride stupid hype waves. hype should never enable a bad product. We would just waste our users time + our own time. be rational.

## Todo

1. We could use https://packages.debian.org/stable/admin/unattended-upgrades to auto upgrade installed `apt` packages.
2. A lightweight version of Chromix should probably also be available as a "Debian Blend" - https://www.debian.org/blends.

## Future ideas

- WebGPU. proxy every game, app, window, audio + video, into wasm-land. play minecraft in your browser.
