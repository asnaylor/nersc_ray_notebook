# nersc_ray_notebook
Using Ray to perform hyperparameter optimization for an ML model all within a Jupyter Notebook. 

## Goals

- ~~Create notebook~~ [x]
- ~~Deploy and connect Ray cluster from notebook~~
    + cori [x]
    + pm [x]
- ~~Sucessfully test the Ray cluster from notebook~~
- Try on PM gpus
- Try on [cori-gpus](https://docs-dev.nersc.gov/cgpu/) (not a priority, focus on PM)
- Get dashboard working in jupyter-hub
- ~~Test Ray tune/test proper Ray ML example~~ [x]
- ~~get tensorboard working ~~ [x]
- ~~Neaten code/setup for submission~~
- ~~Move to shifter~~[x]
- Move to SFAPI
- Move to Jinja2

## Setup
Use the script provided to setup a Jupyter kernel for a specified shifter image:

```bash
./setup.sh <image-name> [-n <kernel-name>] [-b <python-binary-path>]`
```


## Examples

The [notebooks](notebooks) folder contains a set of example notebooks. See the [Getting Started](getting_started.ipynb) notebook

---

# Notes

- Check out using ray-lightning 
