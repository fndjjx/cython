import array
import time
from cython_test6 import f,ff
import random

a=array.array("d",[0])*3000000
for i in range(3000000):
    if random.random()>0.6:
        a[i]=1


b=array.array("d",[0])*3000000




s=time.time()
print(f(a,b))
e=time.time()
print(e-s)


s=time.time()
print(ff(a,b))
e=time.time()
print(e-s)

