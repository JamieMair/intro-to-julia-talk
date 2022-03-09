# Language interop in Julia
using PyCall
using Conda


py"""
import numpy as np

def myfunc(x):
    return np.sin(np.pi * x)
"""

myfunc = py"myfunc"

myfunc(10.0)


# Conda.add("scipy")
# Call Python functions from inside Julia, even with Julia functions as arguments
optim = pyimport("scipy.optimize")
optim.newton(x -> cos(x) - x, 1)