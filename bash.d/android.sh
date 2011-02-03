#!/bin/bash

export ANDROID_ROOT=/Volumes/Android/ncl
export ANDROID_HOST=darwin-x86
export ANDROID_IMGS=/Volumes/Android/imgs

export ANDROID_DFLT_IMGDIR="container/goldfish"
export ANDROID_DFLT_PRODUCT="generic"

export ANDROID_KERNEL_DIR="/Volumes/Android/kernel/cm"

# source the setup file!
ANDROID_ENV=/Volumes/Android/user-ac/scripts/android-env.sh
if [ -e $ANDROID_ENV ]; then
	. $ANDROID_ENV
fi

