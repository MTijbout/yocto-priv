#!/usr/bin/env bash

###
### Define working directory for the build.
###
#POKYCONTAINER="/usr/DataLocal/linux/Yocto/rpi3-warrior"
#POKYCONTAINER="/usr/DataLocal/linux/Yocto/jumpnowtek"
POKYCONTAINER="/usr/DataLocal/linux/Yocto/rpi-instructables"

# Check dir $POKYCONTAINER
if [ ! -d $POKYCONTAINER ]; then
    echo "Repository not available. Create."
    mkdir -p $POKYCONTAINER
else
    echo "Repository available. Skip."
fi

cd $POKYCONTAINER

docker run --rm -it -v $POKYCONTAINER:/workdir crops/poky --workdir=/workdir