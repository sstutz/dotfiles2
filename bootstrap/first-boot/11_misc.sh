#!/usr/bin/env bash


,optional_keyboard_settings() {
    # Set virtual console keyboard mapping
    localectl set-keymap us

    # set-x11-keymap parameters: X11-layout X11-model X11-variant X11-options
    localectl set-x11-keymap us,de pc104 nodeadkeys compose:caps,grp:win_space_toggle
}


,optional_replace_dbus() {
    ,info "Replace dbus"
    systemctl disable dbus

    pacman -S dbus-broker
    systemctl enable dbus-broker
}


,optional_install_avahi() {
    pacman -S avahi nss-mdns
    systemctl enable avahi-daemon
    # disable systemd-resolvd multicastDNS
    sed -i 's/#MulticastDNS=.*/MulticastDNS=no/' /etc/systemd/resolved.conf
    sed -i 's/hosts:.*/hosts: files mymachines myhostname mdns_minimal [NOTFOUND=return] resolve [!UNAVAIL=return] dns/' /etc/nsswitch.conf
}


,optional_install_bluetooth() {
    ,info "install bluetooth support"
    pacman -S bluez bluez-utils
    sed -i 's/\#autoenable=.*/autoenable=true/' "/etc/bluetooth/main.conf"
    systemctl enable bluetooth
}


,optional_install_cups() {
    pacman -S cups cups-pdf
    # socket activation only starts the service when its required.
    systemctl enable cups.socket
}


,optional_install_additional_software() {
    pacman -S \
        ttf-liberation \ # MS compatible fonts
        ttf-font-awesome \
        ttf-roboto ttf-roboto-mono ttf-roboto-mono-nerd \
        noto-fonts noto-fonts-emoji \
        ttf-fira-code ttf-fira-mono ttf-fira-sans ttf-firacode-nerd \
        ttf-hack \
        ttf-iosevka-nerd ttf-iosevkaterm-nerd \
        ttf-fantasque-sans-mono ttf-fantasque-nerd
        go php ghostscript tmux git htop tree mtr sysstat \
        vint shellcheck sshfs fuseiso udisks2 usbutils cifs-utils \
        playerctl strace ripgrep fzf openssh arch-wiki-docs arch-wiki-lite \
        nmap fwupd jq \
        git-delta \
        bat eza btop \
        zoxide \ # cd alternative
        fastfetch \
        tealdeer \ # tldr implementation
        plocate \ # faster mlocate
        moreutils \ # collection of the unix tools, including sponge
        enchant aspell aspell-en aspell-de \ # spell checking
        cloc \ # Lines of Code stats
        cifs-utils \ # mount network shares
        ctags \ # tag files for source code
        tig \ # interactive git client
        pv \ # progress viewer of data through pipelines
        sqlfluff # dialect-flexible and configurable SQL linter.

        systemctl enable fwupd-refresh.timer
        systemctl enable sysstat
        systemctl enable plocate-updatedb.timer
}

,optional_aur_packages() {
    yay \
        sttr-bin \ # string manipulation helper
        ttf-icomoon-feather \ # icon font
        ttf-material-design-icons-git # google material icon
}

,optional_systemd_oomd() {
    yay -S systemd-oomd-defaults
    systemctl enable systemd-oomd
}


,optional_install_yay_aur_helper() {
    cd /tmp || exit
    git clone https://aur.archlinux.org/yay.git
    cd yay || exit
    makepkg -sicr --noconfirm
}


,optional_install_grml_rescue() {
local grml_version="2024.12"
local iso="grml-small-${grml_version}-amd64.iso "
local link="https://download.grml.org/$iso"
local dest="/tmp/$iso"
curl -Lf -o "$dest" "$link"

local relevant_files=(
    live/grml64-small/grml64-small.squashfs
    boot/grml64small/vmlinuz
    boot/grml64small/initrd.img
)

pushd "/tmp" || return

7z e -o/boot/grml "$dest" -- "${relevant_files[@]}"

rm "$dest"

cat <<EOT > /boot/loader/entries/grml.conf
title   Grml Live Linux
version $grml_version
linux   /grml/vmlinuz
initrd  /grml/initrd.img
options lang=us utc tz="$DF_TIMEZONE" apm=power-off boot=live live-media-path=/grml/ nomce net.ifnames=0
EOT
popd || return
}
