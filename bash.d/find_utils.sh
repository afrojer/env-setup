
# find-in-files implementation
__fif() {
	local GREP_ARGS=
	local PAT=$1
	shift

	if [ "$PAT" = "-ga" ]; then
		GREP_ARGS=$1
		shift
		PAT=$1
		shift
	fi

	local DIR=${1:-.}
	shift

	until [ -z "$DIR" ]; do
		find "${DIR}" -type f -print0 | xargs -0 grep $GREP_ARGS --color -n "$PAT"
		DIR=$1
		shift
	done
}

# find-in-files: ignore warnings/errors
fif() {
	local PAT=${1/ /\\ }
	shift
	if [ "$PAT" = "-h" ]; then
		echo "usage: fif [-ga] {pattern} [directory]"
		echo "        -ga [options]    : 'options' are passed directly to grep"
		echo "        {pattern}        : simple pattern or POSIX regex (grep style"
		echo "        [directory]      : directory to search (defaults to ./)"
		echo ""
		return
	elif [ "$PAT" = "-ga" ]; then
		local GA=$1
		shift
		PAT=${1/ /\\ }
		shift
		__fif -ga $GA "$PAT" $@ 2>/dev/null
	else
		__fif "$PAT" $@ 2>/dev/null
	fi
}

# Find a file in the current, or specified directory
ff() {
	FNAME=$1
	if [ -z "$FNAME" -o "$FNAME" = "-h" ]; then
		echo "usage: ff [name_of_file] {dir}"
	else
		find ${2:-.} -type f -name ${FNAME}
	fi
}
