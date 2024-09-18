#!/usr/bin/env bash

# allow memebers of wheel to execute any command
echo "%wheel ALL=(ALL) ALL" > /etc/sudoers.d/wheel

systemctl enable systemd-homed

# https://wiki.archlinux.org/title/Users_and_groups#Group_list
# homectl does not create groups, make sure they exist first!
homectl create "$DF_USERNAME" \
    --shell=/usr/bin/zsh \
    --member-of=wheel,adm,docker,rfkill

