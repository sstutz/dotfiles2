#!/usr/bin/env bash

pacstrap -K "$DF_MOUNT" \
    base base-devel \
    linux linux-firmware linux-headers dkms \
    btrfs-progs cryptsetup \
    man-pages man-db \
    xdg-utils xdg-user-dirs \
    net-tools iputils bind iwd \
    sudo zsh vim \
    smartmontools hwinfo \
    zip unzip unrar p7zip bzip2 \
    terminus-font wget \
    curl wget sed gawk which polkit \
    pipewire pipewire-pulse \ # audio, alternative to pulseaudio
    intel-ucode

