#!/usr/bin/env bash

cryptsetup open \
    --type plain \
    --cipher aes-xts-plain64 \
    --key-size 512 \
    --key-file /dev/urandom \
    "$DF_DISK" container

dd if=/dev/zero of=/dev/mapper/container status=progress bs=1M 2>&1

cryptsetup close container


# The GPT typecodes in the second row are used for systemd to discover/auto mount on boot
#
# | ESP                         | XBOOTLDR                             | System Install             |
# |-----------------------------|--------------------------------------|----------------------------|
# | /dev/nvme0n1p1              | /dev/nvme0n1p2                       | /dev/nvme0n1p4             |
# | ef00 (EFI System Partition) | ea00 (extended linux boot partition) | 8304 Root Partition x86-64 |
# |                             |                                      | LUKS2 encrypted            |

# `--change-name` sets a partition label (PARTLABEL) which allows us to
# use a name to look up partitions in /dev/disk/by-partylabel/$PARTLABEL
#
# if space is an issue lower ESP to 550MiB, lower should be avoided though [^2]
sgdisk --zap-all "$DF_DISK"
sgdisk --clear \
    --new=1:0:+1GiB --typecode=1:ef00 --change-name=1:ESP \
    --new=2:0:+1GiB --typecode=2:ea00 --change-name=2:XBOOTLDR \
    --largest-new=3 --typecode=3:8304 --change-name=3:cryptsystem \
    "$DF_DISK"


