#!/usr/bin/env bash

,optional_keyboard_settings() {
    # Set virtual console keyboard mapping
    localectl set-keymap us

    # set-x11-keymap parameters: X11-layout X11-model X11-variant X11-options
    localectl set-x11-keymap us,de pc104 nodeadkeys compose:caps,grp:win_space_toggle
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
    pacman -S bluez bluez-utils bluetui # TUI for managing bluetooth
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
        ttf-fira-code ttf-fira-mono ttf-fira-sans ttf-firacode-nerd \
        ttf-hack \
        ttf-iosevka-nerd ttf-iosevkaterm-nerd \
        ttf-fantasque-sans-mono ttf-fantasque-nerd \
        noto-fonts noto-fonts-emoji \
        go php ghostscript tmux git htop tree mtr sysstat \
        lua luarocks i sshfs fuseiso udisks2 usbutils \
        vint shellcheck sqlfluff shfmt \ # linters
        playerctl wiremix \
        brightnessctl \
        alactritty ghostty \
        fcron \
        strace ripgrep ast-grep fzf openssh arch-wiki-docs arch-wiki-lite \
        nmap fwupd jq \
        git-delta \
        # obsidian \ # note taking
        bat eza btop \
        zoxide \ # cd alternative
        fd \ # find alternative
        fontconfig \
        impala \ # TUI for managing wifi / iwd
        tealdeer \ # tldr implementation
        plocate \ # faster mlocate
        moreutils \ # collection of the unix tools, including sponge
        enchant aspell aspell-en aspell-de \ # spell checking
        harper \ # grammar checker
        cloc \ # Lines of Code stats
        cifs-utils \ # mount network shares
        ctags \ # tag files for source code
        tig \ # interactive git log viewer
        lazygit \ # cli git client
        yazi \ # file manager
        ffmpeg \
        chafa \ # image to text converter for yazi
        poppler \ # pdf previewer
        pv \ # progress viewer of data through pipelines
        xh \ # http client /httpie reimplementation
        glow \ # markdown viewer
        duckdb \ # analytical database
        cmus \ # music player
        switcheroo # image converter

    # allow btrfs mountpoints to be included in locate results
    sed -i 's/PRUNE_BIND_MOUNTS.*/PRUNE_BIND_MOUNTS = "no"/' /etc/updatedb.conf

    systemctl enable fwupd-refresh.timer
    systemctl enable sysstat
    systemctl enable plocate-updatedb.timer
    systemctl enable fcron.service

    # create initital database
    updatedb
}

,optional_aur_packages() {
    yay \
        sttr-bin \ # string manipulation helper
        ttf-icomoon-feather \ # icon font
        ttf-material-design-icons-git # google material icon
}

,install_desktop() {
    pacman -S
        satty grim slurp \ # screenshots and editing
        swayosd \ # screen display for multimedia keys
        swaync \ # notification daemon
        wl-clipboard clipse \ # clipboard manager
        wf-recorder \ # screen recording
}

# alternative application launcher
,optional_setup_walker() {
    yay -S walker-bin \
        elephant \
        elephant-providerlist \
        elephant-websearch \
        elephant-symbols \
        elephant-unicode \
        elephant-archlinuxpkgs \
        elephant-bluetooth \
        elephant-desktopapplications \
        elephant-files \
        elephant-menus \
        elephant-runner

    # add these to sway autostart
    # exec walker --gapplication-service
    # exec elephant
}

,optional_systemd_oomd() {
    yay -S systemd-oomd-defaults
    systemctl enable systemd-oomd
}

,optional_localsend() {
    # open source alternative to AirDrop
    yay -S localsend-bin
}

,optional_install_yay_aur_helper() {
    cd /tmp || exit
    git clone https://aur.archlinux.org/yay.git
    cd yay || exit
    makepkg -sicr --noconfirm
}

,optional_install_grml_rescue() {
    local grml_version="2026.09"
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

    cat <<EOT >/boot/loader/entries/grml.conf
title   Grml Live Linux
version $grml_version
linux   /grml/vmlinuz
initrd  /grml/initrd.img
options lang=us utc tz="Europe/Berlin" apm=power-off boot=live live-media-path=/grml/ nomce net.ifnames=0
EOT
    popd || return
}

,podman() {
    pacman -S podman podman-compose

    sudo usermod \
        --add-subuids 100000-165535 \
        --add-subgids 100000-165535 \
        $USERNAME
}

,paccache() {
    # check/clean pacman cache weekly
    pacman -S --noconfirm pacman-contrib
    systemctl enable paccache.timer
}

,verify() {
    journalctl -k -p 4
    lspci -k
}
