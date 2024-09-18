#!/usr/bin/env bash

echo -n "$DF_DISK_PASSWORD" |
    cryptsetup luksFormat \
        --perf-no_read_workqueue \
        --perf-no_write_workqueue \
        --batch-mode \
        --type luks2 \
        --cipher aes-xts-plain64 \
        --key-size 512 \
        --key-file - \
        /dev/disk/by-partlabel/cryptsystem

echo -n "$DF_DISK_PASSWORD" |
    cryptsetup open \
        --key-file - \
        /dev/disk/by-partlabel/cryptsystem root
