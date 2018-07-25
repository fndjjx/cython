import time
from cython_test import f2,f3,f4
import numpy as np


x = list(range(100000))
s = time.time()
print(f2(x))
e = time.time()
print(e-s)


x = np.array(list(range(100000)),dtype=np.double)
s = time.time()
print(f3(x))
e = time.time()
print(e-s)

x = np.array(list(range(100000)),dtype=np.double)
s = time.time()
print(f4(x))
e = time.time()
print(e-s)



x = list(range(100000))
s = time.time()
print(np.sum(x))
e = time.time()
print(e-s)



