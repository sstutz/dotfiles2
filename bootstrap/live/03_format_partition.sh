#!/usr/bin/env bash

mkfs.fat -F32 -n ESP /dev/disk/by-partlabel/ESP
mkfs.fat -F32 -n XBOOTLDR /dev/disk/by-partlabel/XBOOTLDR
mkfs.btrfs --force --label system /dev/mapper/root


# this layout is inspired by the openSUSE default layout
#
# Systemd mounts a tmpfs to /tmp and btrfs does not snapshot tmpfs's
# therefore we don't need a dedicated /tmp subvolume
#
# the /swap subvolume is for the swapfile
mount -t btrfs LABEL=system "$DF_MOUNT"
btrfs subvolume create "$DF_MOUNT/@"
btrfs subvolume create "$DF_MOUNT/@/root"
btrfs subvolume create "$DF_MOUNT/@/home"
btrfs subvolume create "$DF_MOUNT/@/.snapshots"
btrfs subvolume create "$DF_MOUNT/@/usr/local"
btrfs subvolume create "$DF_MOUNT/@/opt"
btrfs subvolume create "$DF_MOUNT/@/srv"
btrfs subvolume create "$DF_MOUNT/@/swap"
btrfs subvolume create "$DF_MOUNT/@/var"

umount -R "$DF_MOUNT"

mount -t btrfs -o defaults,x-mount.mkdir,compress=lzo,ssd,noatime,space_cache=v2,subvol=@ LABEL=system "$DF_MOUNT"
mount -t vfat  -o defaults,x-mount.mkdir LABEL=ESP "$DF_MOUNT/efi"
mount -t vfat  -o defaults,x-mount.mkdir LABEL=XBOOTLDR "$DF_MOUNT/boot"


# the nodatacow mount option in btrfs affects the entire filesystem so we will have to use
chattr +C "$DF_MOUNT/var"
chattr +C "$DF_MOUNT/swap"

