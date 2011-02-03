# I need a pointer to my config directory in here:
#
# You can probably copy the following lines into: ~/.env-setup
# #!/bin/sh
# export ENV_ROOT=~/.env
#
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

#
# Create LS_COLORS environment variable from .dircolors
#
[[ -r "$ENV_ROOT/gdircolors" ]]; eval $(gdircolors -b "$ENV_ROOT/gdircolors")

# Default MacPorts paths
EXTRA_PATH="/opt/local/bin:/opt/local/sbin"

export PATH="$HOME/bin:$EXTRA_PATH:$PATH"

