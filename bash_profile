# I need a pointer to my config directory in here, and a pointer to a custom
# shell script directory whose contents will be sourced only on this machine.
#
# You can probably copy the following lines into: ~/.env-setup
# #!/bin/sh
# export ENV_ROOT=~/.env
# export ENV_ROOT_EXTRA=~/.bashrc.d

. ~/.env-setup

# aliases are here
. "$ENV_ROOT/bash_alias"

# Run a bunch of scripts in a directory
# (distributed setup)_
if [ -d "$ENV_ROOT/bash.d" ]; then
	for d in "$ENV_ROOT/bash.d/"*; do
		. "$d"
	done
fi

# user config after global
re_ignore="^\."
if [ -d "$ENV_ROOT_EXTRA" ]; then
	for d in "$ENV_ROOT_EXTRA/"*; do
		if [[ "$d" =~ $re_ignore ]]; then
			echo "ignoring env setup file '$d'" > /dev/null
		else
			. "$d"
		fi
	done
fi

#
# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Default MacPorts paths
EXTRA_PATH="/opt/local/bin:/opt/local/sbin"

export PATH="$HOME/bin:$EXTRA_PATH:$PATH"

