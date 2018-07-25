from cython_test5 import f,ff
import numpy as np
import time
import random
import array


a1=np.random.uniform(0,1,10000)
a2=np.random.uniform(0,1,10000)
a3 = np.empty(1000,dtype=object)
for i in range(1000):
    a3[i]=a1


s = time.time()
for i in range(1000):
    f(a3[i],a2)

e = time.time()
print(e-s)

aa1=array.array("d",a1)
aa2=array.array("d",a2)
aa3 = np.empty(1000,dtype=object)
for i in range(1000):
    aa3[i]=aa1


s = time.time()
for i in range(1000):
    ff(aa3[i],aa2)
e = time.time()
print(e-s)



aa1=array.array("d",a1)
aa2=array.array("d",a2)
aa3 = [0]*1000
for i in range(1000):
    aa3[i]=aa1


s = time.time()
for i in range(1000):
    ff(aa3[i],aa2)
e = time.time()
print(e-s)




