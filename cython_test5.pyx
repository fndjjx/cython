
import numpy as np
cimport numpy as np
import numpy.random as random
from cpython cimport array



cpdef f(np.ndarray p1,np.ndarray p2):
    return np.sum((p1-p2)**2)

cpdef ff(array.array[double] p1,array.array[double] p2):
    cdef double result=0
    for i in range(len(p1)):
        result += (p1[i]-p2[i])**2

    return result




        
    
