#!/usr/bin/env bash

BOOTSTRAP_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

usage() {
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo " --install"
    echo " --first-boot"
}

handle_options() {
    if [ "$#" -eq "0" ]; then
        echo "no step has been defined." >&2
        usage
        exit 1
    fi
    while [ $# -gt 0 ]; do
        case $1 in
        -h | --help)
            usage
            exit 0
            ;;
        --install)
            STEP_DIR="install"
            ;;
        --first-boot)
            STEP_DIR="first-boot"
            ;;
        *)
            echo "Invalid option: $1" >&2
            usage
            exit 1
            ;;
        esac
        shift
    done
}

# Main script execution
handle_options "$@"

# the mount for the chroot environment, I don't see why
# this should ever change.
export DF_MOUNT="/mnt"

if [[ "$STEP_DIR" = "install" ]]; then

    # the disk used to install the system on,
    # usually something like /dev/sda
    export DF_DISK="/dev/sda"

    # # according to the docs we should set RTC to UTC and sync
    # # before we run any command that persists anything on disk
    timedatectl set-ntp true
    timedatectl set-local-rtc 0
    hwclock --systohc --utc

    # initialize and populate pacman keys
    # done by pacstrap already?
    # pacman-key --init
    # pacman-key --populate archlinux

    source "$BOOTSTRAP_DIR/live/01_disk_partition.sh"
    source "$BOOTSTRAP_DIR/live/02_disk_encryption.sh"
    source "$BOOTSTRAP_DIR/live/03_format_partition.sh"
    source "$BOOTSTRAP_DIR/live/04_install_base_system.sh"

    arch-chroot -S "$DF_MOUNT" bash <$BOOTSTRAP_DIR/chroot/05_date_time_locale.sh
    env DF_USERNAME="stutz" arch-chroot -S "$DF_MOUNT" bash <$BOOTSTRAP_DIR/chroot/06_system_configuration.sh
    env DF_HOSTNAME="earth" arch-chroot -S "$DF_MOUNT" bash <$BOOTSTRAP_DIR/chroot/07_networking.sh
    arch-chroot -S "$DF_MOUNT" bash <$BOOTSTRAP_DIR/chroot/08_boot_loader.sh

else
    if [[ $(ps --no-headers -o comm 1) != "systemd" ]]; then
        echo "System must be booted with systemd"
        exit 1
    fi

    source "$BOOTSTRAP_DIR/first-boot/09_init_services.sh"
    source "$BOOTSTRAP_DIR/first-boot/11_misc.sh"
fi
