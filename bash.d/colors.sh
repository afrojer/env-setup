# Create LS_COLORS environment variable from .dircolors
#
DIRCOLORS=`which dircolors`
if [ -z "$DIRCOLORS" ]; then
	DIRCOLORS=`which gdircolors`
fi
[[ -r "$ENV_ROOT/gdircolors" ]]; eval $($DIRCOLORS -b "$ENV_ROOT/gdircolors")

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='[\j] \[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\$ '
else
    PS1='[\j] \u@\h:\W\$ '
fi
unset color_prompt force_color_prompt

