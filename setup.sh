#!/bin/bash

#=========================================
# 
# Title: setup.sh
# Author: Andrew Naylor
# Date: Feb 23
# Brief: Setup jupyter kernel using container image
#
#=========================================


## Variables
KERNEL_NAME=''
PYTHON_BIN_PATH='/usr/bin/python'

## Parse Args
usage() {                                 
  echo "Usage: $0 <image-name> [-n <kernel-name>] [-b <python-binary-path>]" 1>&2 
}

exit_abnormal() { 
  usage
  exit 1
}

if [ $# -lt 1 ]; then
    echo "Error: script requires image name"
    exit_abnormal
fi

IMAGE_NAME=$1; shift

while getopts ":n:b:" options; do         
  case "${options}" in                    
    n)                                    
      KERNEL_NAME=${OPTARG}
      ;;
    b)                                    
      PYTHON_BIN_PATH=${OPTARG}
      ;;
    :)
      echo "Error: -${OPTARG} requires an argument."
      exit_abnormal                       # Exit abnormally.
      ;;
    *)                                    # If unknown (any other) option:
      exit_abnormal                       # Exit abnormally.
      ;;
  esac
done


## Kernel variables 
if [ -z "$KERNEL_NAME" ]; then
    JUPYTER_KERNEL=$(echo $IMAGE_NAME | sed -r 's#[/:]+#_#g')
else
    JUPYTER_KERNEL=$KERNEL_NAME
fi
JUPYTER_KERNEL_FOLDER=$HOME/.local/share/jupyter/kernels/$JUPYTER_KERNEL/
CUSTOM_PYTHONUSERBASE=$HOME/.local/perlmutter/$JUPYTER_KERNEL

## Copy files across
echo '<> Create relevant folders and files...'
mkdir -p $JUPYTER_KERNEL_FOLDER
cp scripts/kernel.json $JUPYTER_KERNEL_FOLDER
sed -i -e "s#CUSTOM_KERNEL_NAME#$JUPYTER_KERNEL#g" $JUPYTER_KERNEL_FOLDER/kernel.json
sed -i -e "s#CUSTOM_SHIFTER_IMAGE#$IMAGE_NAME#g" $JUPYTER_KERNEL_FOLDER/kernel.json
sed -i -e "s#CUSTOM_PYTHON_BIN#$CUSTOM_PYTHON_BIN#g" $JUPYTER_KERNEL_FOLDER/kernel.json
sed -i -e "s#CUSTOM_PYTHONUSERBASE#$CUSTOM_PYTHONUSERBASE#g" $JUPYTER_KERNEL_FOLDER/kernel.json

## Install extra libraries
echo '<> Installing extra libraries via pip'
mkdir -p $CUSTOM_PYTHONUSERBASE
shifter --image=$IMAGE_NAME --env PYTHONUSERBASE=$CUSTOM_PYTHONUSERBASE python3 -m pip install -r scripts/requirements.txt --user

echo "<!> Setup complete: $JUPYTER_KERNEL Jupyter kernel created"