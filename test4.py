from cython_test4 import cross,cross2,mutate,mutate2
import numpy as np
import time
import random
import array

c1 = np.zeros(300,dtype=int)
c1[np.random.uniform(0,1,300)>0.6]=1
c2 = np.zeros(300,dtype=int)
c2[np.random.uniform(0,1,300)>0.6]=1
c1.dtype=int
c2.dtype=int
print(c1.dtype)
print(c2.dtype)

s = time.time()
print(cross(c1,c2))
e = time.time()
print(e-s)

s = time.time()
print(mutate(c1))
e = time.time()
print(e-s)


c1=array.array("i",[0])*300
for i in range(len(c1)):
    if random.random()>0.6:
        c1[i]=1

c2=array.array("i",[0])*300
for i in range(len(c2)):
    if random.random()>0.6:
        c2[i]=1
    



s = time.time()
print(cross2(c1,c2))
e = time.time()
print(e-s)

s = time.time()
print(mutate2(c1))
e = time.time()
print(e-s)




