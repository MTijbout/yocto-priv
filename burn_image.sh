#!/usr/bin/env bash


source /usr/DataLocal/linux/Yocto/poky-warrior/oe-init-build-env /usr/DataLocal/linux/Yocto/rpi/build

cd /usr/DataLocal/linux/Yocto/rpi/meta-rpi/scripts

sudo mk2parts.sh sda

export OETMP=/usr/DataLocal/linux/Yocto/rpi/build/tmp
export MACHINE=raspberrypi3

./copy_boot.sh sda

./copy_rootfs.sh sda console yoctopi3

