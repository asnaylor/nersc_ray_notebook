#!/bin/python3

#=========================================
# 
# Title: utility.py
# Author: Andrew Naylor
# Date: Jan 23
# Brief: Useful functions 
#
#=========================================

## Imports
import math
import os
import ray


## Variables
SCRATCH_FILE = os.path.join(os.getenv('SCRATCH'), 'ray_cluster', 'head_node_address')


## Functions
def get_ray_cluster_address():
    """Get the ray head node address from the scratch file."""
    with open(SCRATCH_FILE) as f:
        node_address = f.read().strip('\n')
    return 'ray://{}:10001'.format(node_address)

def convert_size(size_bytes):
    if size_bytes == 0:
        return "0B"
    size_name = ("B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB")
    i = int(math.floor(math.log(size_bytes, 1024)))
    p = math.pow(1024, i)
    s = round(size_bytes / p, 2)
    return "%s %s" % (s, size_name[i])

def cluster_summary():
    node_resources = ray.cluster_resources()

    print("Cluster Summary")
    print("---------------")
    print("Nodes: {:0.0f}".format(len([i for i in node_resources if 'node' in i])))
    print("CPU:   {:0.0f}".format(node_resources['CPU']))
    print("GPU:   {:0.0f}".format(node_resources.get('GPU', 0)))
    print("RAM:   {}".format(convert_size(node_resources['memory'])))
    return
