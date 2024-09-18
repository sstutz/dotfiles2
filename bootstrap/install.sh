#!/usr/bin/env bash

BOOTSTRAP_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

usage() {
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo " --live"
    echo " --chroot"
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
            --live)
                STEP_DIR="live";
                ;;
            --chroot)
                STEP_DIR="chroot";
                ;;
            --first-boot)
                STEP_DIR="first-boot";
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

# the disk used to install the system on,
# usually something like /dev/sda
export DF_DISK="/dev/sda"

# the mount for the chroot environment, I don't see why
# this should ever change.
export DF_MOUNT="/mnt"

# machines hostname
export DF_HOSTNAME="earth"

export DF_TIMEZONE="Europe/Berlin"

export DF_USERNAME="stutz"

if [[ "$STEP_DIR" = "live" ]]; then
    # # according to the docs we should set RTC to UTC and sync
    # # before we run any command that persists anything on disk
    timedatectl set-ntp true
    timedatectl set-local-rtc 0
    hwclock --systohc --utc

    source "$BOOTSTRAP_DIR/live/01_disk_partition.sh"
    source "$BOOTSTRAP_DIR/live/02_disk_encryption.sh"
    source "$BOOTSTRAP_DIR/live/03_format_partition.sh"
    source "$BOOTSTRAP_DIR/live/04_install_base_system.sh"

     # once the live step is done we'll move the files into the
     # $DF_MOUNT directory to access them in a chroot environment
     cp -rf "$BOOTSTRAP_DIR" "$DF_MOUNT/"

elif [[ "$STEP_DIR" = "chroot" ]]; then
    arch-chroot "$DF_MOUNT" bash /bootstrap/chroot/05_date_time_locale.sh
    arch-chroot "$DF_MOUNT" bash /bootstrap/chroot/06_system_configuration.sh
    arch-chroot "$DF_MOUNT" bash /bootstrap/chroot/07_networking.sh
    arch-chroot "$DF_MOUNT" bash /bootstrap/chroot/08_boot_loader.sh

else
    if [[ $(ps --no-headers -o comm 1) != "systemd" ]]; then
        echo "System must be booted with systemd"
        exit 1
    fi

    source "$BOOTSTRAP_DIR/first-boot/09_init_services.sh"
    source "$BOOTSTRAP_DIR/first-boot/10_create_user.sh"
    source "$BOOTSTRAP_DIR/first-boot/11_misc.sh"
fi

