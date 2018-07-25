from cython_test3 import f,ff,fff,ffff
import time


s = time.time()
print(f())
e = time.time()
print(e-s)


s = time.time()
print(ff())
e = time.time()
print(e-s)

s = time.time()
print(fff())
e = time.time()
print(e-s)

s = time.time()
print(ffff())
e = time.time()
print(e-s)



