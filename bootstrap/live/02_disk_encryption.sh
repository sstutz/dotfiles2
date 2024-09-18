#!/usr/bin/env bash

,install_prompt_for_disk_pass() {
    attempts=0
    while [[ -z "$DF_DISK_PASSWORD" ]]
    do
        read -p "Disk encryption password: " -r
        read -p "Repeat: " -r DF_DISK_PASS_CONFIRM
        echo
        if [[ "$REPLY" != "$DF_DISK_PASS_CONFIRM" ]]; then
            attempts=$((attempts+1))
            if [[ "$attempts" -ge 3 ]]; then
                echo "failed too many times, abort."
                exit 1;
            fi

            echo "Password did not match, retry.. attempt $attempts of 3"
            continue;

        fi

        export DF_DISK_PASSWORD="$REPLY"
    done
} && ,install_prompt_for_disk_pass


echo -n "$DF_DISK_PASSWORD" | \
    cryptsetup luksFormat \
    --perf-no_read_workqueue \
    --perf-no_write_workqueue \
    --batch-mode \
    --type luks2 \
    --cipher aes-xts-plain64 \
    --key-size 512 \
    --key-file - \
    /dev/disk/by-partlabel/cryptsystem


echo -n "$DF_DISK_PASSWORD" | \
    cryptsetup open \
    --key-file - \
    /dev/disk/by-partlabel/cryptsystem root
