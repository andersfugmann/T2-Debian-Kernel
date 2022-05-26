#!/bin/bash

set -eu -o pipefail

USE_T2LINUX_REPO=false
if [[ ($USE_T2LINUX_REPO != true) && ($USE_T2LINUX_REPO != false) ]]
then
echo "Abort!"
exit 1
fi

KERNEL_VERSION=6.0
PKGREL=1

APPLE_BCE_REPOSITORY=https://github.com/kekrby/apple-bce.git
APPLE_IBRIDGE_REPOSITORY=https://github.com/Redecorating/apple-ib-drv.git
REPO_PATH=$(pwd)
WORKING_PATH=/tmp/build
KERNEL_PATH=${WORKING_PATH}/linux-${KERNEL_VERSION}
PACKAGE_PATH=${REPO_PATH}/packages

### Debug commands
echo "Kernel version: ${KERNEL_VERSION}"
echo "Working path: ${WORKING_PATH}"
echo "Current path: ${REPO_PATH}"
echo "Package path: ${PACKAGE_PATH}"

echo "CPU threads: $(nproc --all)"
grep 'model name' /proc/cpuinfo | uniq
### Clean up
rm -fr *deb
rm -fr ${WORKING_PATH}
mkdir -p "${WORKING_PATH}" && cd "${WORKING_PATH}"

### Dependencies
echo >&2 "===]> Info: Setup Debian... "
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y build-essential fakeroot libncurses-dev bison flex libssl-dev libelf-dev \
  openssl dkms libudev-dev libpci-dev libiberty-dev autoconf wget xz-utils git \
  libcap-dev bc rsync cpio debhelper kernel-wedge curl gawk dwarves zstd

## apt build-dep linux

### get Kernel and Drivers
echo >&2 "===]> Info: Obtain sources... "

curl https://mirrors.edge.kernel.org/pub/linux/kernel/v5.x/linux-${KERNEL_VERSION}.tar.xz | tar -C ${WORKING_PATH} -Jx
git clone --depth 1 "${APPLE_BCE_REPOSITORY}" "${KERNEL_PATH}/drivers/staging/apple-bce"
git clone --depth 1 "${APPLE_IBRIDGE_REPOSITORY}" "${KERNEL_PATH}/drivers/staging/apple-ibridge"

#### Create patch file with custom drivers
echo >&2 "===]> Info: Updating patches... "
mkdir -p ${WORKING_PATH}/patches
cp -f ${REPO_PATH}/patches/*.patch ${WORKING_PATH}/patches
WORKING_PATH="${WORKING_PATH}" ${REPO_PATH}/patch_driver.sh

cd "${KERNEL_PATH}" || exit
echo >&2 "===]> Info: Applying patches... "
while read -r file; do
  echo "==> Adding $file"
  patch -p1 < "$file"
done < <(find "${WORKING_PATH}/patches" -type f -name "*.patch" | sort)

echo >&2 "===]> Info: Bulding src... "

make -C ${KERNEL_PATH} clean

echo >&2 "===]> Info: Update config... "
# Copy the modified config
cat "${REPO_PATH}/templates/default-config" | \
    sed 's/CONFIG_VERSION_SIGNATURE=.*/CONFIG_VERSION_SIGNATURE=""/g' |
    sed 's/CONFIG_SYSTEM_TRUSTED_KEYS=.*/CONFIG_SYSTEM_TRUSTED_KEYS=""/g' |
    sed 's/CONFIG_SYSTEM_REVOCATION_KEYS=.*/CONFIG_SYSTEM_REVOCATION_KEYS=""/g' |
    sed 's/CONFIG_DEBUG_INFO=y/# CONFIG_DEBUG_INFO is not set/g' |
    sed 's/CONFIG_CONSOLE_LOGLEVEL_DEFAULT=.*/CONFIG_CONSOLE_LOGLEVEL_DEFAULT=4/g' |
    sed 's/CONFIG_CONSOLE_LOGLEVEL_QUIET=.*/CONFIG_CONSOLE_LOGLEVEL_QUIET=1/g' |
    sed 's/CONFIG_MESSAGE_LOGLEVEL_DEFAULT=.*/CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4/g' > ${KERNEL_PATH}/.config

echo >&2 "===]> Info: Make oldconfig... "
make -C ${KERNEL_PATH} olddefconfig


make olddefconfig
./scripts/config --module CONFIG_BT_HCIBCM4377

# Get rid of the dirty tag
echo "" > ${KERNEL_PATH}/.scmversion

# Build Deb packages
make -C ${KERNEL_PATH} -j "$(getconf _NPROCESSORS_ONLN)" bindeb-pkg LOCALVERSION=-t2 KDEB_PKGVERSION="$(make kernelversion)-$PKGREL"

ls -l ${WORKING_PATH}/*.deb

#### Copy artifacts
echo >&2 "===]> Info: Copying debs and calculating SHA256 ... "
mkdir -p ${PACKAGE_PATH}
rm -f ${WORKING_PATH}/linux-image-*-dbg_*.deb
cp -v ${KERNEL_PATH}/.config ${PACKAGE_PATH}/kernel_config_${KERNEL_VERSION}
cp -v ${WORKING_PATH}/*.deb ${PACKAGE_PATH}
sha256sum ${WORKING_PATH}/*.deb > ${PACKAGE_PATH}/sha256

echo >&2 "===]> Info: Clean up build dir"
rm -fr ${WORKING_PATH}
