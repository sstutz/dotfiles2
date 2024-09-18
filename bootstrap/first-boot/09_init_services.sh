#!/usr/bin/env bash
#
# we need docker installed before we add
# the user so we can add it to the docker
# group.
pacman -S --noconfirm reflector docker

cat <<EOT >/etc/xdg/reflector/reflector.conf
 --save /etc/pacman.d/mirrorlist
 --protocol https
 --latest 5
 --sort age
 --country Germany
EOT
systemctl enable reflector.timer

mkdir -p /etc/docker/
cat <<'EOT' >/etc/docker/daemon.json
{
    "storage-driver": "btrfs",
    "bip": "172.26.0.1/16",
    "experimental": true,
    "dns": ["10.0.0.2", "1.1.1.1"]
}
EOT
systemctl enable docker.socket
