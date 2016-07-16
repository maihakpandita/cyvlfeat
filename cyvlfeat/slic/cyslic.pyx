# Copyright (C) 2007-12 Andrea Vedaldi and Brian Fulkerson.
# All rights reserved.
#
# This file is part of the VLFeat library and is made available under
# the terms of the BSD license (see the COPYING file).

# no need for division import -> we need already integer output here -> 2
import numpy as np
cimport numpy as np
import ctypes
cimport cython
import cython
from libc.stdio cimport printf

# Import the header files
from cyvlfeat._vl.slic cimport *
from cyvlfeat._vl.host cimport *

@cython.boundscheck(False)
cpdef cy_slic(np.ndarray[float, ndim=2, mode='c'] image, int region_size,
              float regularizer, bint verbose):
    # check data types from online reference
    cdef:
        vl_size width = image.shape[1]
        vl_size height = image.shape[0]
        vl_size n_channels = 1
        # vl_size n_channels = image.shape[2]
        int min_region_size = -1
        np.ndarray[unsigned int, ndim=2, mode='c'] segmentation

    if min_region_size < 0:
        #FIXME: Check weather C returns a float here by division.
        # (region_size * region_size) / (6*6)
        min_region_size = region_size * region_size/36
        printf("min_reigon_size cannot be less than 0. Assigning min_reigon_size = %d\n", min_region_size)

    if verbose:
         printf(regularizer)
            # printf("vl_slic: image:         [%d x %d x %d]\n",
            #        width, height, n_channels)
            # printf("vl_slic: region size:           %d\n",
            #        region_size)
            # # print("vl_slic: regularizer:    "regularizer)
            # printf("vl_slic: regularizer:           %d\n", regularizer)
            # printf("vl_slic: min region size:           %d\n",
            #        min_region_size)

    segmentation = np.zeros((height, width), dtype=np.uint32, order='C')

    vl_slic_segment(&segmentation[0,0], &image[0, 0], height, width, n_channels,
                    region_size, regularizer, min_region_size)

    return np.asarray(segmentation)
