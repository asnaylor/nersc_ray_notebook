#!/bin/bash

#=========================================
# 
# Title: setup.sh
# Author: Andrew Naylor
# Date: Feb 23
# Brief: Setup nersc ML examples
#
#=========================================

## Parse Args
usage() {                                 
    echo "Usage: ./setup.sh <Exercise Number> [--dev]" 1>&2 
}

exit_abnormal() { 
    usage
    kill -INT $$
}

if [ $# -lt 1 ]; then
    echo "Error: script requires exercise number"
    exit_abnormal
fi

setup_env() {
  ML_MODULE=$1
  module load $ML_MODULE
  echo "<> Setting up $ML_MODULE env"

  if python -m pip freeze | grep -q nersc-cluster-deploy
    then  
      echo "<!> nersc_cluster_deploy is already setup..."
      return
  fi

  echo "<> Install nersc_cluster_deploy"
  if [ "$DEV_FLAG" == "true" ]
  then
    pushd ../nersc_cluster_deploy
    python -m pip install -e .
    popd
  else
    python -m pip install git+https://github.com/asnaylor/nersc_cluster_deploy.git
  fi

  echo "<> Install additional requirements"
  python -m pip install -r requirements.txt
}

# setup_hvd_pytorch(){
#   if python -m pip freeze | grep -q horovod
#     then  
#       echo "<!> horovod is already setup..."
#       return
#   fi
  
#   HOROVOD_NCCL_HOME=$NCCL_HOME \
#   HOROVOD_GPU_OPERATIONS=NCCL \
#   HOROVOD_NCCL_LINK=SHARED \
#   HOROVOD_WITH_PYTORCH=1 \
#   python3 -m pip install horovod[pytorch]
# }

EX_NUM=$1
if [ "$2" == "--dev" ]; then DEV_FLAG=true; else DEV_FLAG=false; fi

case $EX_NUM in

  1)
    echo "<> Setting up Ex1: Tuning Hyperparameters of a Distributed PyTorch Model with PBT using Ray Train & Tune"
    setup_env pytorch/1.13.1
    ;;

  2)
    echo "<> Setting up Ex2: Tuning Hyperparameters of a Distributed TensorFlow Model using Ray Train & Tune"
    setup_env tensorflow/2.9.0
    ;;

  # 3) #current issue with hvd build `horovod.common.exceptions.HorovodInternalError: ncclAllReduce failed: unhandled cuda error`
  #   echo "<> Setting up Ex3: PyTorch MNIST Example: Ray + Horovod"
  #   setup_env pytorch/1.13.1
  #   setup_hvd_pytorch
  #   ;;

  *)
    echo "Not a valid exercise number..."
    echo $EX_NUM
    exit_abnormal
    ;;
esac

echo "<> Setup complete"