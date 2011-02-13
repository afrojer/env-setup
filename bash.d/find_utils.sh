
# find-in-files implementation
__fif() {
	local PAT=$1
	shift
	local DIRS=${1:-*}
	if [ "x$DIRS" != "x*" ]; then
		shift
	fi

	find -E . -type f -print0 | xargs -0 grep --color -n "$PAT" $DIRS "$@"
}

# find-in-files: ignore warnings/errors
fif() {
	__fif "${1/ /\\ }" ${2:-*} 2>/dev/null
}

# Find a file in the current, or specified directory
ff() {
	FNAME=$1
	if [ -z "$FNAME" ]; then
		echo "usage: ff [name_of_file] {dir}"
	else
		find ${2:-.} -type f -name ${FNAME}
	fi
}
