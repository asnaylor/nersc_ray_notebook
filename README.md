# nersc_ray_notebook
Using Ray to perform hyperparameter optimization for an ML model all within a [Jupyter Notebook](example_notebook.ipynb).

## Goals

- Create notebook [x]
- Deploy and connect Ray cluster from notebook
- Sucessfully test the Ray cluster from notebook
- Look at [cori-gpu](https://docs-dev.nersc.gov/cgpu/)
- Try on PM gpus
- Test Ray tune

## Setup
Run `source setup.sh` to create a conda environment with RAY and other require libraries installed.


---

# Notes

- Cannot connect to ray cluster via notebook:
    ```
2023-01-19 18:32:38,615	INFO worker.py:1333 -- Connecting to existing Ray cluster at address: nid00911:6379...
2023-01-19 18:32:43,630	WARNING utils.py:1333 -- Unable to connect to GCS at nid00911:6379. Check that (1) Ray GCS with matching version started successfully at the specified address, and (2) there is no firewall setting preventing access.
    ```
- Might be worth trying this in interactive to see if it's a firewall thing. Didn't work with shifter or bare metal (conda)