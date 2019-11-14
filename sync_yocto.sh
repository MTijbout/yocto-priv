#!/usr/bin/env bash

PATH_SOURCE1=/opt/yocto/rpi/
PATH_DESTINATION1=/home/sysadmin/shares/yocto/rpi/

PATH_SOURCE2=/opt/yocto/poky-warrior/
PATH_DESTINATION2=/home/sysadmin/shares/yocto/poky-warrior/

rsync -avu --delete "$PATH_SOURCE1" "$PATH_DESTINATION1"
rsync -avu --delete "$PATH_SOURCE2" "$PATH_DESTINATION2"

