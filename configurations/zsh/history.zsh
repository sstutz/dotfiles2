#!/usr/bin/env zsh

# set in $HOME/.zshenv
[[ -d "$ZDATADIR" ]] || mkdir -p "$ZDATADIR"

# Refers to the path/location of the history file
HISTFILE="$ZDATADIR/zhistory"

# Refers to the number of commands that are stored in the zsh HISTFILE
SAVEHIST=50000

# Refers to the number of commands that are loaded into memory from the HISTFILE
# HIST_EXPIRE_DUPS_FIRST requires this value to be larger than SAVEHIST
HISTSIZE=$(($SAVEHIST * 2))

# zsh sessions wont overwrite the history file but rather append their history
setopt INC_APPEND_HISTORY_TIME

# Do not enter command lines into the history list if they begin with a blank
setopt HIST_IGNORE_SPACE

# If a new command line being added to the history list duplicates an older one
# the older command is removed from the list (even if it is not the previous event).
setopt HIST_IGNORE_ALL_DUPS

# Do not enter command lines into the history list if they are duplicates of the previous event.
setopt HIST_IGNORE_DUPS

# When writing out the history file,
# older commands that duplicate newer ones are omitted.
setopt HIST_SAVE_NO_DUPS

# When searching for history entries in the line editor,
# do not display duplicates of a line previously found,
# even if the duplicates are not contiguous.
setopt HIST_FIND_NO_DUPS

# perform history substitution and reload the line into the editing buffer
setopt HIST_VERIFY

# Write the history file in the ":start:elapsed;command" format.
setopt EXTENDED_HISTORY

setopt HIST_EXPIRE_DUPS_FIRST

# Remove superfluous blanks before recording entry.
setopt HIST_REDUCE_BLANKS

# Beep in ZLE when a widget attempts to access a history entry which isn’t there.
setopt HIST_BEEP

# ignore certain commands
export HISTORY_IGNORE="(z|ls|rg|cat|cd|ll)"
