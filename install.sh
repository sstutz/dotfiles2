#!/usr/bin/env bash

# passing --install will trigger load scripts that
# set up archlinux.
if [[ $* == "--install" ]]; then
    ,dotfiles_initial_system_configuration() {
        if [[ "$EUID" -ne 0 ]]; then
            echo "This command requires root privileges"
            exit 1
        fi

        local lockfile="/root/.config/dotfiles-init-system"
        if [[ -f $lockfile ]]; then
            echo "This can only be run once (lockfile already exists)"
            exit 0
        fi

        source "$DOTFILES/bootstrap/install.sh --live"

        touch $lockfile
    } && ,dotfiles_initial_system_configuration "$@"
else

    # By default ZSH sources the .zshenv file if it exists
    # the location of the file cannot be changed though so
    # we'll have to symlink it.
    ,dotfiles_symlink_zsh_env_file() {
        local envfile="$HOME/.zshenv"
        if [[ ! -f "$envfile" ]]; then
            local cwd=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
            ln -sf "$cwd/configurations/zsh/.zshenv" "$envfile"
            source "$envfile"
        fi
    } && ,dotfiles_symlink_zsh_env_file

    ,dotfiles_symlink_configuration_files() {
        local cwd=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

        ln -sf "$cwd/configurations/alacritty" "$XDG_CONFIG_HOME"
        ln -sf "$cwd/configurations/ghostty" "$XDG_CONFIG_HOME"
        ln -sf "$cwd/configurations/ctags" "$XDG_CONFIG_HOME"
        ln -sf "$cwd/configurations/git" "$XDG_CONFIG_HOME"
        ln -sf "$cwd/configurations/nvim" "$XDG_CONFIG_HOME"
        ln -sf "$cwd/configurations/scripts" "$XDG_CONFIG_HOME"
        ln -sf "$cwd/configurations/starship" "$XDG_CONFIG_HOME"
        ln -sf "$cwd/configurations/sway" "$XDG_CONFIG_HOME"
        ln -sf "$cwd/configurations/swaync" "$XDG_CONFIG_HOME"
        ln -sf "$cwd/configurations/vim" "$XDG_CONFIG_HOME"
        ln -sf "$cwd/configurations/walker" "$XDG_CONFIG_HOME"
        ln -sf "$cwd/configurations/waybar" "$XDG_CONFIG_HOME"
        ln -sf "$cwd/configurations/xdg-dektop-portal" "$XDG_CONFIG_HOME"
        ln -sf "$cwd/configurations/tmux" "$XDG_CONFIG_HOME"

        echo "Dotfiles linked."
    } && ,dotfiles_symlink_configuration_files
fi
