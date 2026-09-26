#!/usr/bin/env zsh

ZCOMPDUMP_PATH="$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"

autoload -Uz compinit

if [[ ! -d "$XDG_CACHE_HOME/zsh" ]]; then
    mkdir -p "$XDG_CACHE_HOME/zsh";
    compinit -d "$ZCOMPDUMP_PATH";
fi

# returns the day of the year of the last write or 0 if the file doesn't exist
# typeset -i updated_at=$(date +'%j' -r "$ZCOMPDUMP_PATH" 2>/dev/null || stat -f '%Sm' -t '%j' "$ZCOMPDUMP_PATH" 2>/dev/null)
# if [ $(date +'%j') != $updated_at ]; then
if [ ! -f "$ZCOMPDUMP_PATH" -o "$(find "$ZCOMPDUMP_PATH" -mtime "+2")" ]; then
    compinit -d "$ZCOMPDUMP_PATH"
else
    # load the zcompdump without updating
    compinit -CD -di "$ZCOMPDUMP_PATH"

    # asynchronously rebuild the zcompdump file
    # (autoload -Uz compinit; compinit -d "$ZCOMPDUMP_PATH" &);
fi

# completion syntax
# allows you to configure specific commands, functions, arguments,
# :completion:<function>:<completer>:<command>:<argument>:<tag>

# # enable caching to speed up completion
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/compcache"
#
# # enable the completion menu
zstyle ':completion:*' menu select
#
# # enable autocompletion of privileged environments
# # zstyle ':completion::complete:*' gain-privileges 1
#
# # add the completion description to the output
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
#
# # enable grouping
zstyle ':completion:*' group-name ''
zstyle ':completion:*:*:-command-:*:*' group-order alias builtins functions commands
#
# # case insensitive path-completion, based on compinstall
# zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'
#
# # ignore functions not available on the system
# zstyle ':completion:*:functions' ignored-patterns '_*'
#
# # add git completion
# if [[ -f "/usr/share/git/completion/git-completion.zsh" ]]; then
#     zstyle ':completion:*:*:git:*' script "/usr/share/git/completion/git-completion.zsh"
#     fpath=("/usr/share/git/completion" $fpath)
# fi
#
# # add a local site-function directory for custom completion
# if [[ ! -d "$HOME/.local/share/zsh/site-functions" ]]; then
#     mkdir -p "$HOME/.local/share/zsh/site-functions"
# fi
# fpath+=("$HOME/.local/share/zsh/site-functions")

# # AWS CLI v2 comes with its own autocompletion.
# if command -v aws_completer &> /dev/null; then
#     if [[ -f "/usr/bin/aws_zsh_completer.sh" ]]; then
#         source /usr/bin/aws_zsh_completer.sh
#     else
#       autoload -Uz bashcompinit && bashcompinit
#       complete -C aws_completer aws
#     fi
# fi

# # make shift-tab autocomplete backwards
zmodload zsh/complist
bindkey -M menuselect '^[[Z' reverse-menu-complete

bindkey " " magic-space
