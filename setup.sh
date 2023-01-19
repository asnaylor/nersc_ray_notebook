#!/bin/bash

#=========================================
# 
# Title: setup.sh
# Author: Andrew Naylor
# Date: Jan 23
# Brief: setup conda environment with ray
#
#=========================================

## Variables
CONDA_RAY_ENV=ray_ml_env
module load python

## Create
echo '<> Building new env...'
mamba create -n $CONDA_RAY_ENV ipykernel python=3.8.13 -y #Set the version to match latest nersc pytorch image

## Activate
echo '<> Activating conda env'
conda activate $CONDA_RAY_ENV

echo '<> Install libraries via pip'
python3 -m pip install -r requirements.txt

## Setup for JupyterHub
echo '<> Installing kernel in JupyterHub'
python3 -m ipykernel install --user --name $CONDA_RAY_ENV --display-name $CONDA_RAY_ENV

echo "<!> Setup complete, to activate conda env: conda activate $CONDA_RAY_ENV"