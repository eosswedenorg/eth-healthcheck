#!/bin/bash

############################
#  Exported variables.     #
############################

export BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if [ $# -lt 2 ]; then
    echo "$0 <pkg_type> <build_dir>"
    exit 1
fi

PKG_TYPE=$1
BUILD_DIR=$2

PKG_SCRIPT="${BASE_DIR}/pkg_${PKG_TYPE}.sh"

# Check and call script
if [ ! -x $PKG_SCRIPT ]; then
    echo "$PKG_SCRIPT not found"
    exit 1
fi

# Info
set -o allexport
source ${BUILD_DIR}/pkg_info
set +o allexport

# Directories.
export PACKAGE_BINDIR=${PACKAGE_PREFIX}/bin
export PACKAGE_SHAREDIR=${PACKAGE_PREFIX}/share/${PACKAGE_NAME}
export PACKAGE_TMPDIR="${BUILD_DIR}/pkg_${PKG_TYPE}"
export BUILD_DIR

$PKG_SCRIPT
