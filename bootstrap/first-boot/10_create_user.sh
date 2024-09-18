#!/usr/bin/env bash

# allow memebers of wheel to execute any command
#

cat <<EOF > /etc/sudoers.d/wheel
Defaults passwd_timeout = 0
Defaults timestamp_type = global
Defaults timestamp_timeout = 15
%wheel ALL=(ALL) ALL
EOF

systemctl enable systemd-homed

# https://wiki.archlinux.org/title/Users_and_groups#Group_list
# homectl does not create groups, make sure they exist first!
homectl create "$DF_USERNAME" \
    --shell=/usr/bin/zsh \
    --member-of=wheel,adm,docker,rfkill


# create default xdg user directories,
# defaults may be changed by creating
# ~/.config/user-dirs.dirs
# cat <<'EOT' > "/home/$DF_USERNAME/.config/user-dirs.dirs"
# XDG_DESKTOP_DIR="$HOME/Desktop"
# XDG_DOCUMENTS_DIR="$HOME/Documents"
# XDG_DOWNLOAD_DIR="$HOME/Downloads"
# XDG_MUSIC_DIR="$HOME/Music"
# XDG_PICTURES_DIR="$HOME/Pictures"
# XDG_PUBLICSHARE_DIR="$HOME/Public"
# XDG_TEMPLATES_DIR="$HOME/Templates"
# XDG_VIDEOS_DIR="$HOME/Videos"
# EOT

