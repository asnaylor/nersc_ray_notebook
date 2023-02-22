# nersc_ray_notebook
Using Ray to perform hyperparameter optimization for an ML model all within a Jupyter Notebook. This repo utilises the [`nersc_cluster_deploy`](https://github.com/asnaylor/nersc_cluster_deploy) python library to create the Ray clusters easily via the SF API all within a Jupyter Notebook.
 
## Tutorials

These example [notebooks](notebooks) will cover how different machine learning frameworks and codes.

|     | Notebook | Description |
| :-- | :----- | :---------- |
| 1  | [PyTorch MNIST Example: Ray + Horovod](notebooks/ex_01_pytorch_ray_hvd.ipynb) | Deploying a Ray cluster via shifter in order to run Ray with Horovod. |

> **Note**
> To setup the environment for each notebook, execute on command line: `./setup.sh <exercise-number>` (e.g `./setup.sh 1a`).

---

## Goals

- Try on [cori-gpus](https://docs-dev.nersc.gov/cgpu/)
- move to nersc_cluster_deploy
    - Get dashboard working in jupyter-hub/nersc_cluster_deploy
    - Test on cori (need a solution for getting the ip-address [possibly ssh to job & `hostname -I`])
- update setup script
- restructure repo