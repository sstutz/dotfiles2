#!/usr/bin/env bash

pacstrap -K "$DF_MOUNT" \
    base base-devel \
    linux linux-firmware linux-headers dkms \
    btrfs-progs cryptsetup \
    man-pages man-db \
    xdg-utils xdg-user-dirs \
    net-tools iputils bind iwd \
    sudo zsh vim nvim \
    smartmontools hwinfo \
    zip unzip unrar p7zip bzip2 \
    terminus-font \
    curl wget sed gawk which polkit fcron \
    pipewire pipewire-pulse \
    amd-ucode

genfstab -t PARTLABEL "$DF_MOUNT" >>"$DF_MOUNT/etc/fstab"
