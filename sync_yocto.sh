#!/usr/bin/env bash

PATH_SOURCE1=/opt/yocto/rpi/
PATH_DESTINATION1=/home/sysadmin/shares/yocto/rpi/

PATH_SOURCE2=/opt/yocto/poky-warrior/
PATH_DESTINATION2=/home/sysadmin/shares/yocto/poky-warrior/

## Check dir /home/sysadmin/shares/yocto
if [ ! -d /home/sysadmin/shares/yocto ]; then
    echo -e "\nShares to host not mounted. Mount." >> $LOG_FILE
    /usr/bin/vmhgfs-fuse .host:/ /home/sysadmin/shares -o subtype=vmhgfs-fuse,allow_other
else
    echo "Shares to host already mounted. Skip." >> $LOG_FILE
fi

## Synchronise the whole bunch
echo -e "\nStarting the synchronisation:\n"
rsync -avu --delete "$PATH_SOURCE1" "$PATH_DESTINATION1"
rsync -avu --delete "$PATH_SOURCE2" "$PATH_DESTINATION2"

