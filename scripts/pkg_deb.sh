#!/usr/bin/env bash

PACKAGE_ARCH=amd64

if [[ -f /etc/upstream-release/lsb-release ]]; then
    source /etc/upstream-release/lsb-release
elif [[ -f /etc/lsb-release ]]; then
    source /etc/lsb-release
else
    echo "ERROR: could not determine debian release."
    exit 1
fi

DISTRIB_ID=$(echo $DISTRIB_ID | tr '[:upper:]' '[:lower:]')

# Default to 1 if no release is set.
if [[ -z $RELEASE ]]; then
    RELEASE="1"
fi

PACKAGE_FULLNAME="${PACKAGE_NAME}_${PACKAGE_VERSION}-${RELEASE}-${DISTRIB_ID}-${DISTRIB_RELEASE}_${PACKAGE_ARCH}"

rm -fr ${PACKAGE_TMPDIR}

# Create debian files.
mkdir -p ${PACKAGE_TMPDIR}/DEBIAN
echo "Package: ${PACKAGE_NAME}
Version: ${PACKAGE_VERSION}-${RELEASE}
Section: introspection
Priority: optional
Architecture: ${PACKAGE_ARCH}
Homepage: https://github.com/eosswedenorg/eth-healthcheck
Maintainer: Henrik Hautakoski <henrik@eossweden.org>
Description: ${PACKAGE_DESCRIPTION}" &> ${PACKAGE_TMPDIR}/DEBIAN/control

cat ${PACKAGE_TMPDIR}/DEBIAN/control

# Copy program
mkdir -p ${PACKAGE_TMPDIR}/${PACKAGE_BINDIR}
cp ${BUILD_DIR}/${PACKAGE_PROGRAM} ${PACKAGE_TMPDIR}/${PACKAGE_BINDIR}/${PACKAGE_NAME}

# Copy files.
mkdir -p ${PACKAGE_TMPDIR}/${PACKAGE_SHAREDIR}
cp ${BASE_DIR}/../LICENSE ${PACKAGE_TMPDIR}/${PACKAGE_SHAREDIR}

fakeroot dpkg-deb --build ${PACKAGE_TMPDIR} ${BUILD_DIR}/${PACKAGE_FULLNAME}.deb
