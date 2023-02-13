#!/bin/sh
# SPDX-License-Identifier: MIT

set -e

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

export VERSION_FLAG=https://github.com/MageiaLinuxOnSiliconDevices/installer/latest
export INSTALLER_BASE=https://github.com/MageiaLinuxOnSiliconDevices/installer/
export INSTALLER_DATA=https://github.com/MageiaLinuxOnSiliconDevices/.config/installer_data.json
export REPO_BASE=https://github.com/MageiaLinuxOnSiliconDevices/

#TMP="$(mktemp -d)"
TMP=/tmp/asahi-install

echo
echo "Bootstrapping installer:"

mkdir -p "$TMP"
cd "$TMP"

echo "Checking version..."

PKG_VER="$(curl -s -L "$VERSION_FLAG")"
echo "Version: $PKG_VER"

PKG="installer-$PKG_VER.tar.gz"

echo "Downloading..."

curl -s -L -o "$PKG" "$INSTALLER_BASE/$PKG"
curl -s -L -O "$INSTALLER_DATA"

echo "Extracting..."

tar xf "$PKG"

echo "Initializing..."
echo

if [ "$USER" != "root" ]; then
    echo "The installer needs to run as root."
    echo "Please enter your sudo password if prompted."
    exec caffeinate -dis sudo -E ./install.sh "$@"
else
    exec caffeinate -dis ./install.sh "$@"
fi

