#!/usr/bin/env zsh

,configure-fzf() {
    if ! command -v fzf &> /dev/null; then
        return;
    fi

    # <CTRL+T> list files+folders in current directory
    # <CTRL+R> search history of shell commands
    # <ALT+C> fuzzy change directory
    if command -v fd >/dev/null; then
        # fzf settings. Uses sharkdp/fd for a faster alternative to `find`.
        export FZF_DEFAULT_COMMAND='fd --type f --color=never'
        export FZF_CTRL_T_COMMAND='fd --type f --hidden --exclude .git --exclude .cache'
        export FZF_ALT_C_COMMAND='fd --type d'
        zle -N fzf
    fi

    zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
} && ,configure-fzf

# we'll have to source the zsh bindings after
# zsh-vi-mode has been initialized
# to make sure it does not override ctrl-r
zvm_after_init() {
    eval "$(fzf --zsh)"
}
