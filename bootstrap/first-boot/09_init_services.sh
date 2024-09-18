#!/usr/bin/env bash

# use systemd-timesyncd for NTP synchronisation
timedatectl set-ntp true
timedatectl set-timezone "$DF_TIMEZONE"
timedatectl set-local-rtc 0
hwclock --systohc --utc
systemctl enable systemd-timesyncd



# does this do more than just setting /etc/hostname?
hostnamectl set-hostname "$(/usr/bin/cat /etc/hostname)"


# we need docker installed before we add
# the user so we can add it to the docker
# group.
pacman -S --noconfirm reflector docker


cat <<EOT > /etc/xdg/reflector/reflector.conf
 --save /etc/pacman.d/mirrorlist
 --protocol https
 --latest 5
 --sort age
 --country Germany
EOT
systemctl enable reflector.timer


mkdir -p /etc/docker/
cat <<'EOT' > /etc/docker/daemon.json
{
    "storage-driver": "btrfs",
    "bip": "172.26.0.1/16",
    "experimental": true,
    "dns": ["10.0.0.2", "1.1.1.1"]
}
EOT
systemctl enable docker
