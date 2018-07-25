import time
from gp_cython4 import gpp


s = time.time()
gpp(100,100,0.8,0.8)
e = time.time()
print(e-s)



