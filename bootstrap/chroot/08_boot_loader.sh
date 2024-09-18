#!/usr/bin/env bash

bootctl --esp-path=/efi --boot-path=/boot install

cat <<EOT > /efi/loader/loader.conf
timeout         0
console-mode    max
editor          no
EOT


cat <<EOT > /etc/mkinitcpio.d/linux.preset
# mkinitcpio preset file for the 'linux' package

PRESETS=('default' 'fallback')

ALL_kver="/boot/vmlinuz-linux"

default_uki="/efi/EFI/Linux/arch-linux.efi"
default_options="--splash=/usr/share/systemd/bootctl/splash-arch.bmp"

fallback_uki="/efi/EFI/Linux/arch-linux-fallback.efi"
fallback_options="-S autodetect"
EOT


# only required if multiple btrfs devices exist
#sed -i 's/BINARIES=()/BINARIES=(btrfs)/' /etc/mkinitcpio.conf
sed -i 's/^HOOKS=.*/HOOKS=(base\ systemd\ keyboard\ autodetect\ microcode\ sd-vconsole\ modconf\ kms\ block\ sd-encrypt\ filesystems\ fsck)/' /etc/mkinitcpio.conf

mkdir -p /etc/cmdline.d
cat <<EOT > /etc/cmdline.d/root.conf
root=LABEL=system
rootflags=subvol=@
rw

# Hide all systemd messages at startup
# quiet

# disable watchdog
nowatchdog

# disable zswap, we'll use zram
zswap.enabled=0

# disable kernel audit
audit=0
EOT

mkdir -p /efi/EFI/Linux
mkinitcpio -P

systemctl enable systemd-boot-update
