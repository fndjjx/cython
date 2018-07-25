import time
import random
from cpython cimport array






cpdef double f(array.array[double] a,array.array[double] b):
    cdef double result=0
    for i in range(3000000):
        result += (a[i]-b[i])**2

    return -result


cpdef double ff(array.array[double] a,array.array b):
    cdef double result=0
    for i in range(3000000):
        result += (a[i]-b[i])**2
    
    return -result





