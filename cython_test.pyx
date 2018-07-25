import numpy as np
cimport numpy as np

cdef f(double a[100000]):
    cdef double result=0
    for i in range(100000):
        result += a[i]
    return result


cpdef f2(a):
    cdef double aa[100000] 
    for i in range(100000):
        aa[i] = a[i]
    
    return f(aa)

cpdef f3(np.ndarray[double,ndim=1] a):
    return np.sum(a) 

cpdef f4(np.ndarray a):
    return np.sum(a)

#cdef ffff(np.ndarray x):
#    x[0]=1
#
#cpdef fff():
#    cdef np.ndarray[double,ndim=2] x=np.zeros([2,2])
#    print(x)
#    ffff(x)
#    print(x)

    


