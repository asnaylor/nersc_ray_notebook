#!/bin/bash

#=========================================
# 
# Title: sbatch_submit_script.sbatch
# Author: Andrew Naylor
# Date: Jan 23
# Brief: Sbatch script
#
#=========================================


## Setup
module load python
conda activate ray_ml_env

nodes=$(scontrol show hostnames $SLURM_JOB_NODELIST) # Getting the node names
nodes_array=( $nodes )

node_1=${nodes_array[0]} 
node_1_ip=$node_1
RAY_HEAD_PORT=6379
ip_head=$node_1_ip:$RAY_HEAD_PORT
RAY_NODE_ADDRESS=$ip_head
export RAY_NODE_ADDRESS
echo "[slurm] - IP Head: $RAY_NODE_ADDRESS"
RAY_SCRATCH_FOLDER=$SCRATCH/ray_cluster
mkdir -p $RAY_SCRATCH_FOLDER
echo $RAY_NODE_ADDRESS > ${RAY_SCRATCH_FOLDER}/head_node_address

## Start ray Head
echo "[slurm] - Starting ray HEAD"
srun --nodes=1 --ntasks=1 -w $node_1 ray start --head --node-ip-address=$node_1_ip --port=$RAY_HEAD_PORT --block &
#srun --nodes=1 --ntasks=1 -w $node_1 shifter ray start --head --node-ip-address=$node_1_ip --port=$RAY_HEAD_PORT --block &

sleep 30 ##needed?

## Start ray workers
worker_num=$(($SLURM_JOB_NUM_NODES - 1)) #number of nodes other than the head node
echo "[slurm] - Starting $worker_num ray worker"
for ((  i=1; i<=$worker_num; i++ ))
do
  node_i=${nodes_array[$i]}
  echo "    - $i at $node_i"
  srun --nodes=1 --ntasks=1 -w $node_i ray start --address $RAY_NODE_ADDRESS --block &
  #srun --nodes=1 --ntasks=1 -w $node_i shifter ray start --address $RAY_NODE_ADDRESS --block &
done

sleep infinity

echo "[slurm] Exiting slurm script..."
exit
