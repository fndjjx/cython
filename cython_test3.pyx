
import numpy as np
cimport numpy as np
import numpy.random as random
from cpython cimport array

cpdef f():
    cdef int target[300]
    for i in range(300):
        if random.random()>0.6:
            target[i]=1
        else:
            target[i]=0
    return target

cpdef ff():
    cdef np.ndarray target
    target = np.zeros(300)
    target[np.random.uniform(0,1,300)>0.6]=1
    return target

cpdef fff():
    cdef np.ndarray target=np.zeros(300,dtype=int)
    for i in range(300):
        if random.random()>0.6:
            target[i]=1

    return target

cpdef ffff():
    cdef array.array target=array.array("i",[0])*300
    for i in range(300):
        if random.random()>0.6:
            target[i]=1

    return target


