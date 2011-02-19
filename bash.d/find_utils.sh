
# find-in-files implementation
__fif() {
	local PAT=$1
	shift

	local DIR=${1:-.}
	shift
	until [ -z "$DIR" ]; do
		find "${DIR}" -type f -print0 | xargs -0 grep --color -n "$PAT"
		DIR=$1
		shift
	done
}

# find-in-files: ignore warnings/errors
fif() {
	local PAT=${1/ /\\ }
	shift
	__fif "$PAT" $@ 2>/dev/null
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
