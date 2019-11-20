#!/bin/bash
#

# if [ "$(/bin/ls -1A | wc -l)" -ne "0" ]; then
#     echo Please run this from an empty directory.
#     exit 1
# fi

## Yocto flavor:
YOCTO_RELEASE=warrior


BASE=$(pwd -P)




###
### Install packages needed by Yocto
###
# sudo apt-get update
# sudo apt-get install -y gawk wget git-core diffstat unzip texinfo gcc-multilib \
#      build-essential chrpath socat cpio python python3 python3-pip python3-pexpect \
#      xz-utils debianutils iputils-ping libsdl1.2-dev xterm

###
### Clone Yocto layers
###
mkdir ${BASE}/src
git clone -b $YOCTO_RELEASE git://git.yoctoproject.org/poky ${BASE}/src/poky
git clone -b $YOCTO_RELEASE git://git.openembedded.org/meta-openembedded ${BASE}/src/meta-openembedded
git clone -b $YOCTO_RELEASE git://git.yoctoproject.org/meta-raspberrypi ${BASE}/src/meta-raspberrypi

###
### Create the base build directory
###
source ${BASE}/src/poky/oe-init-build-env ${BASE}/build

# bitbake-layers add-layer ${BASE}/src/meta-openembedded/meta-oe
# bitbake-layers add-layer ${BASE}/src/meta-openembedded/meta-python
# bitbake-layers add-layer ${BASE}/src/meta-openembedded/meta-multimedia
# bitbake-layers add-layer ${BASE}/src/meta-openembedded/meta-networking
# bitbake-layers add-layer ${BASE}/src/meta-raspberrypi


cat >> ${BASE}/build/conf/local.conf <<EOF

###################################################
###
### Configuration added by Raspi-Buildv2.sh
###
###################################################
MACHINE = "raspberrypi3"
PREFERRED_VERSION_linux-raspberrypi = "4.19%"
DISTRO_FEATURES_remove = "x11 wayland"
DISTRO_FEATURES_append = " systemd"
VIRTUAL-RUNTIME_init_manager = "systemd"
IMAGE_FSTYPES = "ext4 tar.xz rpi-sdimg"

EOF

###
### Run the build.
###    This will take a long time; go for a walk, or a meal, or a nap
###
time bitbake core-image-full-cmdline

###
### Cleanup
###
echo Congratulations.  Your Yocto build for Raspberry Pi 3 is finished.
echo Please deploy the file:
echo     ${BASE}/build/tmp/deploy/images/raspberrypi3/core-image-full-cmdline-raspberrypi3.rpi-sdimg
echo to an SDCard and boot your board.
