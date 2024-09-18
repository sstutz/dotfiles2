#!/usr/bin/env bash

# add crypttab to initram so we can decrypt the partition during boot
# man crypttab for flag inforamtions, tl;dr SSD performance and TRIM support
echo "system    /dev/disk/by-partlabel/cryptsystem  none    discard,no-read-workqueue,no-write-workqueue" >> "/etc/crypttab.initramfs"

# set the default subv to the one holding the OS
# systemd will boot the default value when nothing else is configured
btrfs subvolume set-default "$(btrfs subv list / | head -n 1 | cut -f2 -d' ')" /


# ls -l /usr/share/kbd/consolefonts/* for availble fonts
# font name explained: https://www.if-not-true-then-false.com/2024/fedora-terminus-console-font/
cat <<EOT > /etc/vconsole.conf
KEYMAP=us
FONT=ter-v24n
FONT_MAP=8859-1_to_uni
UNICODE=1
EOT


echo "EDITOR=vim" >> /etc/environment
echo "VISUAL=vim" >> /etc/environment


# disable beep sounds..
echo "blacklist pcspkr" > /etc/modprobe.d/nobeep.conf


# disable watchdogs
cat > /etc/modprobe.d/nowatchdogs.conf <<EOF
blacklist iTCO_wdt
blacklist iTCO_vendor_support
blacklist sp5100_tco
EOF

# allow btrfs mountpoints to be included in locate results
sed -i 's/PRUNE_BIND_MOUNTS.*/PRUNE_BIND_MOUNTS = "no"/' /etc/systemd/resolved.conf

# Misc pacman settings
sed -i 's/#UseSyslog/UseSyslog/' /etc/pacman.conf
sed -i 's/#Color/Color\nILoveCandy/' /etc/pacman.conf
sed -i 's/#VerbosePkgLists/VerbosePkgLists/' /etc/pacman.conf
sed -i 's/#CheckSpace/CheckSpace/' /etc/pacman.conf
sed -i 's/.*ParallelDownloads.*/ParallelDownloads = 10/' /etc/pacman.conf


# move pacman DB into /usr, allows us to snapshot the entire /var directory
sed -i '/^#DBPath/a\DBPath=/usr/pacman/' /etc/pacman.conf
mv /var/lib/pacman /usr/pacman


# disable debug packages when building packages locally
# the whitespace is intentional, otherwise it'd match "!debug" as well
sed -i '/OPTIONS=/s/ debug/ !debug/' /etc/makepkg.conf


# swap configuration.
# we'll use zram for swapping and a swapfile for hibernation.
pacman -S --noconfirm zram-generator


# zram has a higher priority than the swapfile
# that should result in the sysetm using zram over
# the swapfile whenever possible.
cat <<EOT > /etc/systemd/zram-generator.conf
[zram0]
zram-size = ram / 2
swap-priority=100
compression-algorithm = zstd
EOT


# values are taken from the archwiki, based on some fedora research results.
cat <<EOT > /etc/sysctl.d/99-vm-zram-parameters.conf
vm.swappiness = 180
vm.watermark_boost_factor = 0
vm.watermark_scale_factor = 125
vm.page-cluster = 0
EOT


# The only reason to use a swapfile is for hibernation
# this will create a swapfile and set it to a lower priority than zram
# sysetmd hibernate ignores zram devices by default so the swapfile will be used

# available memory in kB
AVAILABLE_MEM=$(grep MemTotal /proc/meminfo | grep -o '[0-9]*')

# recommended size: ram_size + zram_size
SWAP_SIZE=$((AVAILABLE_MEM + (AVAILABLE_MEM / 2)))
SWAP_FILE="/swap/swapfile"

btrfs filesystem mkswapfile --size ${SWAP_SIZE}k --uuid clear "$SWAP_FILE"

# add swapfile, but set priority as low as possible
# so it only gets used if zram (pri=100) can't be
echo "${SWAP_FILE}  none    swap    defaults,pri=0 0 0" > "/etc/fstab"

mkdir -p /etc/cmdline.d
SWAP_OFFSET=$(btrfs inspect-internal map-swapfile -r "$SWAP_FILE")
cat <<EOT > /etc/cmdline.d/resume.conf
# hibernation
resume=LABEL=system
resume_offset=${SWAP_OFFSET}
EOT

swapon "$SWAP_FILE"
systemctl enable systemd-zram-setup@zram0.service
systemctl enable fstrim.timer


# check/clean pacman cache weekly
pacman -S --noconfirm pacman-contrib
systemctl enable paccache.timer


# set root pw to enable login after restart
passwd root
