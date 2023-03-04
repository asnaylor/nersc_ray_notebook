# nersc_ray_notebook
Using Ray to perform hyperparameter optimization for an ML model all within a Jupyter Notebook. This repo utilises the [`nersc_cluster_deploy`](https://github.com/asnaylor/nersc_cluster_deploy) python library to create the Ray clusters easily via the SF API all within a Jupyter Notebook.
 
## Tutorials

These example [notebooks](notebooks) will cover how different machine learning frameworks and codes.

|     | Notebook | Description |
| :-- | :----- | :---------- |
| 1  | [Tuning Hyperparameters of a Distributed PyTorch Model with PBT using Ray Train & Tune](notebooks/ex_01_pytorch_ray_train_tune.ipynb) | Deploying a Ray cluster in order to do Distributed Tunning of Hyperparameters with PyTorch. |
| 2  | [Tuning Hyperparameters of a Distributed TensorFlow Model using Ray Train & Tune](notebooks/ex_02_tensorflow_ray_train_tune.ipynb) | Deploying a Ray cluster in order to do Distributed Tunning of Hyperparameters with TensorFlow. |
| 3  | [PyTorch MNIST Example: Ray + Horovod](notebooks/ex_03_pytorch_ray_hvd.ipynb) | Deploying a Ray cluster in order to run Ray with Horovod. |


> **Note**
> To setup the environment for each notebook, execute on command line: `./setup.sh <exercise-number>` (e.g `./setup.sh 1`).
