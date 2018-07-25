import numpy as np
cimport numpy as np
import numpy.random as random
from cpython cimport array

cdef int length=300
cdef array.array a=array.array('i')


cpdef np.ndarray[long] cross(np.ndarray[long] ch1,np.ndarray[long] ch2):
    cdef int index
    index = int(np.random.uniform(0,length))
    return np.concatenate([ch1[:index],ch2[index:]])

cpdef cross2(array.array ch1,array.array ch2):
    cdef int index=int(random.random()*length)
    cdef array.array new=array.array('i',[0])*300
    for i in range(length):
        if i<index:
            new[i]=ch1[i]
        else:
            new[i]=ch2[i]
    return new


cpdef np.ndarray mutate(np.ndarray ch):
    cdef int index
    index = int(np.random.uniform(0,length))
    new = ch.copy()
    if new[index]>0:
        new[index]=0
    else:
        new[index]=1
    return new





cpdef array.array mutate2(array.array ch):
    cdef int index
    index = int(np.random.uniform(0,length))
    cdef array.array new=array.array('i',[0])*length

    for i in range(length):
        if i!=index:
            new[i]=ch[i]
        else:
            if ch[index]>0:
                new[i]=0
            else:
                new[i]=1
    return new

