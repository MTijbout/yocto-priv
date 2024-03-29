#!/bin/bash
#

# if [ "$(/bin/ls -1A | wc -l)" -ne "0" ]; then
#     echo Please run this from an empty directory.
#     exit 1
# fi

## Yocto flavor:
YOCTO_RELEASE=Warrior


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
git clone -b rocko git://git.yoctoproject.org/poky ${BASE}/src/poky
git clone -b rocko git://github.com/mendersoftware/meta-mender ${BASE}/src/meta-mender
git clone -b rocko git://git.openembedded.org/meta-openembedded ${BASE}/src/meta-openembedded
git clone -b rocko git://git.yoctoproject.org/meta-raspberrypi ${BASE}/src/meta-raspberrypi

###
### Create the base build directory
###
source ${BASE}/src/poky/oe-init-build-env ${BASE}/build
bitbake-layers add-layer ${BASE}/src/meta-openembedded/meta-oe
bitbake-layers add-layer ${BASE}/src/meta-openembedded/meta-python
bitbake-layers add-layer ${BASE}/src/meta-openembedded/meta-multimedia
bitbake-layers add-layer ${BASE}/src/meta-openembedded/meta-networking
bitbake-layers add-layer ${BASE}/src/meta-raspberrypi
bitbake-layers add-layer ${BASE}/src/meta-mender/meta-mender-core
bitbake-layers add-layer ${BASE}/src/meta-mender/meta-mender-raspberrypi

cat >> ${BASE}/build/conf/local.conf <<EOF




###################################################
###
### Configuration added by yocto-mender-rpi3.sh
###
###################################################
MENDER_ARTIFACT_NAME = "release-1"
INHERIT += "mender-full"
MACHINE = "raspberrypi3"
RPI_USE_U_BOOT = "1"
MENDER_PARTITION_ALIGNMENT_KB = "4096"
MENDER_BOOT_PART_SIZE_MB = "40"
IMAGE_INSTALL_append = " kernel-image kernel-devicetree"
IMAGE_FSTYPES_remove += " rpi-sdimg"
# Build for Hosted Mender
# To get your tenant token, log in to https://hosted.mender.io,
# click your email at the top right and then "My organization".
# Remember to remove the meta-mender-demo layer (if you have added it).
# We recommend Mender 1.4.0 and Yocto Project's rocko or later for Hosted Mender.
#
# MENDER_SERVER_URL = "https://hosted.mender.io"
# MENDER_TENANT_TOKEN = "<YOUR-HOSTED-MENDER-TENANT-TOKEN>"
DISTRO_FEATURES_append = " systemd"
VIRTUAL-RUNTIME_init_manager = "systemd"
DISTRO_FEATURES_BACKFILL_CONSIDERED = "sysvinit"
VIRTUAL-RUNTIME_initscripts = ""
IMAGE_FSTYPES = "ext4"
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
echo     ${BASE}/build/tmp/deploy/images/raspberrypi3/core-image-full-cmdline-raspberrypi3.sdimg
echo to an SDCard and boot your board.
echo To use the Mender service, fill in the MENDER_TENANT_TOKEN variable above and rerun this script.
echo You can use the file:
echo     ${BASE}/build/tmp/deploy/images/raspberrypi3/core-image-full-cmdline-raspberrypi3.mender
echo as a deployment artifact.