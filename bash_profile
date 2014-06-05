# I need a pointer to my config directory in here, and a pointer to a custom
# shell script directory whose contents will be sourced only on this machine.
#
# You can probably copy the following lines into: ~/.env-setup
# #!/bin/sh
# export ENV_ROOT=~/.env
# export ENV_ROOT_EXTRA=~/.env.d

. ~/.env-setup

################################################################################
# Custom prompt coloring
################################################################################
SHORT_HOST=`hostname | sed 's/\..*//'`
if [[ "`uname`" == "Darwin" ]]; then
	PS1='\[\033[01;32m\]\w\[\033[00m\]\$ '
else
	PS1='\[\033[01;34m\]\w\[\033[00m\]\$ '
fi

################################################################################
# Custom PATH configuration
################################################################################
# Default MacPorts paths
# EXTRA_PATH="/opt/local/bin:/opt/local/sbin"
EXTRA_PATH="/usr/local/bin:/usr/local/sbin"
# ~/bin
EXTRA_PATH="${EXTRA_PATH}:${HOME}/bin"


################################################################################
# Git settings
################################################################################
export GIT_EDITOR=/usr/bin/vim
export GIT_AUTHOR_NAME="Jeremy C. Andrus"
export GIT_AUTHOR_EMAIL="jeremya@cs.columbia.edu"
export GIT_COMMITTER_NAME="Jeremy C. Andrus"
export GIT_COMMITTER_EMAIL="jeremya@cs.columbia.edu"

################################################################################
# kernel compilation settings
################################################################################
export MENUCONFIG_COLOR=blackbg

################################################################################
# KVM/ARM environment
################################################################################
#function kvmarm_env()
#{
#	export CROSS_COMPILE=arm-linux-gnueabi-
#	export ARCH=arm
#	export GIT_AUTHOR_NAME="Christoffer Dall"
#	export GIT_AUTHOR_EMAIL="c.dall@virtualopensystems.com"
#	export GIT_COMMITTER_NAME="Christoffer Dall"
#	export GIT_COMMITTER_EMAIL="c.dall@virtualopensystems.com"
#}

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

# Run a bunch of scripts in a directory
# (distributed setup)
if [ -d "$ENV_ROOT/bash.d" ]; then
	for d in "$ENV_ROOT/bash.d/"*; do
		. "$d"
	done
fi

# aliases are here
. "$ENV_ROOT/bash_alias"

# user config after global
re_ignore="^\."
if [ -d "$ENV_ROOT_EXTRA" ]; then
	_T=$(ls "$ENV_ROOT_EXTRA")
	if [ ! -z "$_T" ]; then
		for d in "$ENV_ROOT_EXTRA/"*; do
			if [[ ! "$d" =~ $re_ignore ]]; then
				. "$d"
			fi
		done
	fi
fi

export PATH="${EXTRA_PATH}:$PATH"

