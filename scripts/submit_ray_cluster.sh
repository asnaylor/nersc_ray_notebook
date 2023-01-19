#!/bin/bash

#=========================================
# 
# Title: submit_ray_cluster.sh
# Author: Andrew Naylor
# Date: Jan 23
# Brief: Submit ray cluster slurm job 
#
#=========================================

#variables
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
CMD_ARGS=$1
EXTRA_ARGS="--ntasks-per-node=1"
export TMP_RAY_ADDRESS_FILE=$2

#check if cori or PM
if [[ $HOSTNAME == *"cori"* ]]; then
    MACHINE_ARGS="-C haswell --cpus-per-task=64"
else
    MACHINE_ARGS="-C gpu --cpus-per-task=128 --gpus-per-task=4"
fi

#Run sbatch code and then get cluster address
echo "<> Submiting Ray cluster job"
sbatch $CMD_ARGS $EXTRA_ARGS $MACHINE_ARGS $SCRIPT_DIR/sbatch_submit_script.sbatch

