#!/usr/bin/env zsh
if [[ -n $DISPLAY ]]; then
    return
fi

if [[ $(tty) = /dev/tty1 ]]; then
    if uwsm check may-start; then
        export XDG_CURRENT_DESKTOP=sway
        exec uwsm start sway.desktop
    fi
fi

if [[ $(tty) = /dev/tty2 ]] || [[ "$XDG_SESSION_TYPE" = "wayland" ]]; then
    export XDG_CURRENT_DESKTOP=sway

    exec WLR_RENDERER=vulkan sway
fi

# x11 fallback
if [[ $(tty) = /dev/tty3 ]]; then
    startx
fi

