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
    echo "Usage: source setup.sh <Exercise Number> [-f]" 1>&2 
}

exit_abnormal() { 
    usage
    kill -INT $$
}

if [ $# -lt 1 ]; then
    echo "Error: script requires exercise number"
    exit_abnormal
fi

setup_conda() {
    CONDA_RAY_ENV=nersc_cluster_deploy
    module load python
    #Create conda env
    conda create -n $CONDA_RAY_ENV ipykernel python=3.10 -y
    
    #Install library
    source activate $CONDA_RAY_ENV
    python3 -m pip install git+https://github.com/asnaylor/nersc_cluster_deploy.git
    python3 -m ipykernel install --user --name $CONDA_RAY_ENV --display-name $CONDA_RAY_ENV
    source deactivate
}

setup_env(){
    IMAGE_NAME=$1
    JUPYTER_KERNEL=$(echo $IMAGE_NAME | sed -r 's#[/:]+#_#g')
    JUPYTER_KERNEL_FOLDER=$HOME/.local/share/jupyter/kernels/$JUPYTER_KERNEL/
    CUSTOM_PYTHONUSERBASE=$HOME/.local/perlmutter/$JUPYTER_KERNEL

    if [ "$2" == "-f" ]
    then
      echo "<!> Force clearing PYTHONUSERBASE + kernel.json"
      rm -rf $CUSTOM_PYTHONUSERBASE
      rm -rf $JUPYTER_KERNEL_FOLDER
    fi
}

shifter_ml_image(){
    shifter --image=$IMAGE_NAME --module=gpu,nccl-2.15 \
            --env PYTHONUSERBASE=$CUSTOM_PYTHONUSERBASE \
            "$@"
}

setup_shifter_kernel(){
    CUSTOM_PYTHON_BIN=$1
    
    #check folder exists
    if [ -d "$JUPYTER_KERNEL_FOLDER" ]; then
      echo "<!> $JUPYTER_KERNEL is already setup..."
      return
    fi

    ## Copy files across
    mkdir -p $JUPYTER_KERNEL_FOLDER
    cp .kernel.json $JUPYTER_KERNEL_FOLDER/kernel.json
    sed -i -e "s#CUSTOM_KERNEL_NAME#$JUPYTER_KERNEL#g" $JUPYTER_KERNEL_FOLDER/kernel.json
    sed -i -e "s#CUSTOM_SHIFTER_IMAGE#$IMAGE_NAME#g" $JUPYTER_KERNEL_FOLDER/kernel.json
    sed -i -e "s#CUSTOM_PYTHON_BIN#$CUSTOM_PYTHON_BIN#g" $JUPYTER_KERNEL_FOLDER/kernel.json
    sed -i -e "s#CUSTOM_PYTHONUSERBASE#$CUSTOM_PYTHONUSERBASE#g" $JUPYTER_KERNEL_FOLDER/kernel.json

    ## Install library
    mkdir -p $CUSTOM_PYTHONUSERBASE
    shifter --image=$IMAGE_NAME --module=gpu,nccl-2.15 \
            --env PYTHONUSERBASE=$CUSTOM_PYTHONUSERBASE \
            python3 -m pip install git+https://github.com/asnaylor/nersc_cluster_deploy.git --user
}

setup_shifter_hvd_pytorch(){
    #check if horovod installed
    if shifter_ml_image python -m pip freeze | grep -q horovod
    then  
      echo "<!> horovod is already setup..."
      return
    fi

    shifter --image=$IMAGE_NAME --module=gpu,nccl-2.15 \
            --env PYTHONUSERBASE=$CUSTOM_PYTHONUSERBASE \
            --env HOROVOD_NCCL_HOME=/opt/udiImage/modules/nccl-2.15 \
            --env HOROVOD_GPU_OPERATIONS=NCCL \
            --env HOROVOD_NCCL_LINK=SHARED \
            --env HOROVOD_WITH_PYTORCH=1 \
            python3 -m pip install horovod[pytorch]

}


EX_NUM=$1
if [ "$2" == "-f" ]; then FORCE_FLAG=true; else FORCE_FLAG=false; fi

case $EX_NUM in

  1)
    echo "<> Setting up Ex1: PyTorch MNIST Example: Ray + Horovod"
    setup_env nersc/pytorch:ngc-22.09-v0 $FORCE_FLAG
    setup_shifter_kernel /opt/conda/bin/python
    setup_shifter_hvd_pytorch
    shifter_ml_image python -m pip install "ray[air]==2.3.0"
    ;;

  2)
    echo "<> Setting up Ex2: Tuning Hyperparameters of a Distributed PyTorch Model with PBT using Ray Train & Tune"
    setup_env nersc/pytorch:ngc-22.09-v0 $FORCE_FLAG
    setup_shifter_kernel /opt/conda/bin/python
    shifter_ml_image python -m pip install "ray[air]==2.3.0"
    ;;

  3)
    echo "<> Setting up Ex3: Tuning Hyperparameters of a Distributed TensorFlow Model using Ray Train & Tune"
    setup_env nersc/tensorflow:ngc-22.09-tf2-v0 $FORCE_FLAG
    setup_shifter_kernel /usr/bin/python
    shifter_ml_image python -m pip install "ray[air]==2.3.0"
    ;;

  *)
    echo "Not a valid exercise number..."
    echo $EX_NUM
    exit_abnormal
    ;;
esac

echo "<> Setup complete"

#function for doing pip updates etc. - probably wrapper around shifter func with correct setup