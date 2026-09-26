#!/usr/bin/env zsh

# prevent zsh from adding existing records to the path
typeset -U path
typeset -U fpath

# disable software flow control
# stty -ixon
setopt noflowcontrol

# disable warning
setopt NO_WARN_CREATE_GLOBAL

if [[ "$TERM" == "xterm-ghostty" && -n $GHOSTTY_RESOURCES_DIR ]]; then
  source "$GHOSTTY_RESOURCES_DIR/shell-integration/zsh/ghostty-integration"
fi

source "$ZDOTDIR/aliases"
source "$ZDOTDIR/colored-man-pages.zsh"
source "$ZDOTDIR/history.zsh"
source "$ZDOTDIR/plugins.zsh"
source "$ZDOTDIR/fzf.zsh"
source "$ZDOTDIR/golangrc"
source "$ZDOTDIR/rustrc"
source "$ZDOTDIR/rubyrc"
source "$ZDOTDIR/pythonrc"
source "$ZDOTDIR/javarc"
source "$ZDOTDIR/completion.zsh"
source "$ZDOTDIR/init-tmux.zsh"

if [[ -d "$LOCAL_BIN_DIR" ]]; then
    # add users local bin directory to path
    # path is used for binaries that we do
    # not want to commit to the dotfiles repo
    path+="$LOCAL_BIN_DIR"
fi

if [[ -d "$XDG_CONFIG_HOME/scripts" ]]; then
    # add dotfiles scripts bin directory to path
    # kinda like LOCAL_BIN_DIR but these scripts
    # are committed to the dotfiles repo
    path+="$XDG_CONFIG_HOME/scripts"
fi

if [[ -d "$DOTFILES/configurations/git/functions" ]]; then
    # add git custom functions to path
    path+="$DOTFILES/configurations/git/functions"
fi

# add relative paths for php/node projects
path+="./node_modules/.bin"
path+="./vendor/bin"

if command -v yarn &> /dev/null; then
    path+="$(yarn global bin)"
fi

[[ -f "$ZDOTDIR/.zshrc.local" ]] && source "$ZDOTDIR/.zshrc.local"
# ~/.local/share/tig/ for the tig_history file

,install-starship() {
    sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- --bin-dir="$LOCAL_BIN_DIR"
}

,update-tealdeer() {
    if ! command -v /usr/bin/tldr &> /dev/null; then
        return
    fi

    /usr/bin/tldr --update
}

,update-spotify-launcher() {
    if ! command -v /usr/bin/spotify-launcher &> /dev/null; then
        return
    fi

    /usr/bin/spotify-launcher \
        --force-update \
        --no-exec
}

,install-phpantom-lsp() {
    if command -v "$LOCAL_BIN_DIR/phpantom_lsp" &> /dev/null; then
        return
    fi

    local lspTar='phpantom_lsp-x86_64-unknown-linux-gnu.tar.gz'
    /usr/bin/wget -O "$lspTar" "https://github.com/AJenbo/phpantom_lsp/releases/download/0.9.0/$lspTar"

    if [[ -f "$lspTar" ]]; then
        tar -xf "$lspTar" -C $LOCAL_BIN_DIR
        rm "$lspTar"
    fi
}

,update-shell-plugins() {
    ,update-tealdeer
    ,plugin-update
    ,plugin-compile
    ,install-starship
    ,install-phpantom-lsp
    echo 'Plugins and shell updated.'
}

if ! command -v starship &> /dev/null; then
    ,install-starship
fi

if command -v sttr &> /dev/null; then
    source <(sttr completion zsh);
fi

if command -v scloud &> /dev/null; then
    # for what ever reason scloud breaks
    # the shell when I get root permissions..
    if ! [[ $(id -u) = 0 ]]; then
        eval "$(scloud --shell zsh)"
    fi
fi

if command -v mago &> /dev/null; then
    source <(mago generate-completions zsh);
fi


if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
fi

if [[ -d "/opt/paloaltonetworks/globalprotect" ]]; then
    path+="/opt/paloaltonetworks/globalprotect"
fi

eval "$(starship init zsh)"
