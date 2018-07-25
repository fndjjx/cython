import numpy as np
import time




s=time.time()
for i in range(10000):
    np.random.uniform(0,1)
e=time.time()
print(e-s)


s=time.time()
np.random.uniform(0,1,10000)
e=time.time()
print(e-s)


