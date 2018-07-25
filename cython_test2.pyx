import numpy as np
cimport numpy as np

n=1000000
cdef double l[1000000]
l=list(range(n))

cpdef f():
    cdef double r=0
    for i in l:
        r+=i
    return r

cpdef ff():
    return sum(l)

cpdef fff():
    return np.sum(l)
    
    
