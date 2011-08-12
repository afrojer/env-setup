#!/bin/bash
#
# setup.sh
# Setup my environment scripts on a new machine
#

# don't always depend on the 'HOME' env variable...
eval h="~/"
if [ -z "$h" -o "$h" = "~/" ]; then
	echo "hmmm, I can't find your home."
	echo "please install this environment manually."
	echo ""
	exit
fi

#eval mydir_=`dirname $(which $(test -L $0 && readlink $0 || echo $0))`
#mydir=$(echo $mydir_ | sed "s#^\./*#`pwd`/#; s#^\.\./#`pwd`/../#; s#[^/]*/\.\./##")
# this is _much_ cleaner...
#mydir="$(cd "$(dirname $0)" && pwd)"
# but this is much more _stable_
eval SCRIPT_PATH="${BASH_SOURCE[0]}";
if ([ -h "${SCRIPT_PATH}" ]) then
	while([ -h "${SCRIPT_PATH}" ]) do SCRIPT_PATH=`readlink "${SCRIPT_PATH}"`; done
fi
pushd . > /dev/null
cd `dirname ${SCRIPT_PATH}` > /dev/null
SCRIPT_PATH=`pwd`;
popd  > /dev/null

mydir=${SCRIPT_PATH%/}
h=${h%/}

echo "Installing environment in $mydir into $h"
echo -n "Continue? [Y|n] "
read ans
if [ "$ans" = "n" -o "$ans" = "N" -o "$ans" = "no" -o "$ans" = "No" ]; then
	echo "aborting."
	exit
fi

echo "setting up your environment..."
pushd "$h" 2>&1 >/dev/null

# check for existing '.bashrc' or '.bash_profile'
# back them up if they exist
installed_rc=0

backup_dir=".envbackup.$RANDOM$RANDOM"
while [ -d $backup_dir ]; do
	backup_dir=".envbackup.$RANDOM$RANDOM"
done
files_backedup=

function backup_file() {
	local file="$1"
	local dst=$backup_dir/${file#.}
	mkdir -p "$backup_dir" 2>/dev/null
	# do a cp, then rm to handle symlinks somewhat gracefully
	cp "$file" "$dst"
	rm -f "$file"
	files_backedup="$files_backedup\n\t$file -> $dst"
}

if [ -a .bashrc ]; then
	backup_file .bashrc
	if [ $installed_rc -lt 1 ]; then
		ln -s "$mydir/bash_profile" .bashrc
		installed_rc=1
	fi
fi
if [ -a .bash_profile ]; then
	backup_file .bash_profile
	if [ $installed_rc -lt 1 ]; then
		ln -s "$mydir/bash_profile" .bash_profile
		installed_rc=1
	fi
fi
# default to .bashrc link
if [ $installed_rc -lt 1 ]; then
	ln -s "$mydir/bash_profile" .bashrc
	installed_rc=1
fi

if [ -a .env-setup ]; then
	backup_file .env-setup
fi

envroot_extra=${ENV_ROOT_EXTRA:-$h/.env.d}
mkdir -p "$envroot_extra" 2>/dev/null

cat > .env-setup <<ENDENVSETUP
export ENV_ROOT=$mydir
export ENV_ROOT_EXTRA=${envroot_extra}
ENDENVSETUP

popd 2>&1 >/dev/null

echo "Success!"
if [ -d "$backup_dir" ]; then
	echo "Your old files are backed up in: $backup_dir:"
	echo -e $files_backedup
	echo ""
fi
echo "You can now add files to '$envroot_extra'"
echo "and they will be automagically sourced into"
echo "your environment for you at login."
echo ""
echo "You can also force a re-evaluation by:"
if [ -a .bashrc ]; then
	echo "        source $h/.bashrc"
else
	echo "        source $h/.bash_profile"
fi
echo ""
echo "Enjoy!"
echo ""


