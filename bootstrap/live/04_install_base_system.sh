#!/usr/bin/env bash

pacstrap -K "$DF_MOUNT" \
    base base-devel linux linux-firmware linux-headers btrfs-progs \
    cryptsetup vim zsh man-pages man-db \
    xdg-utils xdg-user-dirs sed gawk which polkit \
    iputils bind smartmontools hwinfo iwd sudo curl plocate \
    zip unzip unrar p7zip bzip2 \
    terminus-font wget pipewire pipewire-pulse \
    intel-ucode
