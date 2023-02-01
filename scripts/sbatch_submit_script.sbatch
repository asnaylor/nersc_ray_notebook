#!/bin/bash

#=========================================
# 
# Title: sbatch_submit_script.sbatch
# Author: Andrew Naylor
# Date: Jan 23
# Brief: Sbatch script
#
#=========================================


## Get hostname/IP address
nodes=$(scontrol show hostnames $SLURM_JOB_NODELIST) # Getting the node names
nodes_array=( $nodes )
head_node_hostname=${nodes_array[0]} 
RAY_HEAD_PORT=6379
RAY_NODE_ADDRESS=$head_node_hostname:$RAY_HEAD_PORT
export RAY_NODE_ADDRESS
ip_adresses=($(hostname -i))
head_node_ip_address=${ip_adresses[0]}

echo "[slurm] - IP Head: $RAY_NODE_ADDRESS | $head_node_ip_address"
RAY_SCRATCH_FOLDER=$SCRATCH/ray_cluster
mkdir -p $RAY_SCRATCH_FOLDER
echo $head_node_ip_address > ${RAY_SCRATCH_FOLDER}/head_node_address

## Start ray Head
echo "[slurm] - Starting ray HEAD"
srun --nodes=1 --ntasks=1 -w $head_node_hostname shifter ray start --head --node-ip-address=$head_node_hostname --port=$RAY_HEAD_PORT --block &
sleep 30

## Start ray workers
worker_num=$(($SLURM_JOB_NUM_NODES - 1)) #number of nodes other than the head node
echo "[slurm] - Starting $worker_num ray worker"
for ((  i=1; i<=$worker_num; i++ ))
do
  node_i=${nodes_array[$i]}
  echo "    - $i at $node_i"
  srun --nodes=1 --ntasks=1 -w $node_i shifter ray start --address $RAY_NODE_ADDRESS --block &
done

sleep infinity

echo "[slurm] Exiting slurm script..."
exit
