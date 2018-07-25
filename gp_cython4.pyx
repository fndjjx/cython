import numpy as np
cimport numpy as np
import numpy.random as random
import random
from cpython cimport array
import copy
import cProfile
import line_profiler
import sys
cdef int length = 300

cdef array.array target=array.array("d",[0])*300
for i in range(300):
    if random.random()>0.6:
        target[i]=1
print("target")
print(target)
 



cdef array.array cross(array.array ch1,array.array ch2):
    cdef int index=int(random.random()*length)
    return ch1[:index]+ch2[index:]

cdef array.array mutate(array.array ch):
    cdef int index=int(random.random()*length)

    new = copy.deepcopy(ch)
    if new[index]==1:
        new[index]=0
    else:
        new[index]=1
#    cdef array.array new=array.array('i',[0])*length
#    
#    for i in range(length):
#        if i!=index:
#            new[i]=ch[i]
#        else:
#            if ch[index]>0:
#                new[i]=0
#            else:
#                new[i]=1
    return new


cdef array.array init_chromosome(int length):
    cdef array.array chromosome=array.array("d",[0])*length
    for i in range(length):
        if random.random()>0.6:
            chromosome[i]=1
    return chromosome

cdef double metric(array.array[double] a,array.array[double] b):
    cdef double result=0
    for i in range(length):
        result += (a[i]-b[i])**2
        
    return -result

cdef double metric2(array.array[double] a):

    return np.sum((np.asarray(a)-np.asarray(target))**2)


cdef double metric3(array.array[double] a):
    return 0

cdef evaluate( np.ndarray population, array.array[double] result):
    #cdef int r=len(population)
    #cdef DTYPE_t[:] result = np.empty(r,dtype=np.DTYPE_t)
    for i in range(len(result)):
        #result[i] = metric(population[i])
        result[i] = metric(population[i],target)
    #return result

         
cdef select_mutate2(np.ndarray  population, float rate, np.ndarray p1, int population_num):
    #cdef int r1=int(len(population)*rate)
    #cdef int r2=length
    #cdef int index
    #cdef np.ndarray[:] p1 = np.empty(r1, dtype=np.ndarray)
    for i in range(len(p1)):
        index = int(np.random.uniform(0,population_num,1))
        p1[i] = population[index]
    
    #return p1

cdef select_mutate(np.ndarray  population, float rate, int population_num, int population_num2):
    index = np.random.uniform(0,population_num-1,population_num2).astype(int)
    return population[:population_num][index]



cdef select_cross(np.ndarray population, float rate, int population_num, int population_num2):
    #cdef int r1=int(len(population)*rate)
    #cdef int r2=length
    #cdef np.ndarray[:] p1 = np.empty(r1, dtype=np.ndarray)
    #cdef np.ndarray[:] p2 = np.empty(r1, dtype=np.ndarray)

    #for i in range(len(p1)):
    #    pair = [int(j) for j in np.random.uniform(0,population_num,2)]
    #    p1[i] = population[pair[0]]
    #    p2[i] = population[pair[1]]
    #return p1,p2
    p1_index,p2_index = np.random.uniform(0,population_num-1,[2,population_num2]).astype(int)
    return population[:population_num][p1_index],population[:population_num][p2_index]


cpdef gp(int population_num, int loop_num, float cross_rate, float mutate_rate):
    cdef int population_num1 = population_num
    cdef int population_num2 = int(population_num*cross_rate)
    cdef int population_num3 = int(population_num*mutate_rate)
    cdef int population_num4 = population_num1+population_num2+population_num3

    cdef np.ndarray population = np.empty(population_num1,dtype=object)
    cdef np.ndarray all_population = np.empty(population_num4,dtype=object)

    cdef np.ndarray cross_population1=np.empty(population_num2,dtype=object)
    cdef np.ndarray cross_population2=np.empty(population_num2,dtype=object)
    cdef np.ndarray cross_children=np.empty(population_num2,dtype=object)
    cdef np.ndarray mutate_population=np.empty(population_num3,dtype=object)
    cdef np.ndarray mutate_children=np.empty(population_num3,dtype=object)
    cdef array.array result=array.array("d",[0])*population_num4
    cdef array.array result2=array.array("d",[0])*population_num
    #cdef np.ndarray all_population[population_num+int(population_num*cross_rate)+int(population_num*mutate_rate)]
    #cdef np.ndarray cross_population1[int(population_num*cross_rate)]
    #cdef np.ndarray cross_population2[int(population_num*cross_rate)]
    #cdef np.ndarray cross_children[int(population_num*cross_rate)]
    #cdef np.ndarray mutate_population[int(population_num*mutate_rate)]
    #cdef np.ndarray mutate_children[int(population_num*mutate_rate)]
    #cdef np.ndarray result[population_num]

    for i in range(population_num):
        all_population[i] = init_chromosome(length)

    for i in range(loop_num):
        cross_population1,cross_population2=select_cross(all_population, cross_rate,  population_num,population_num2)
        mutate_population = select_mutate(all_population, mutate_rate,population_num,population_num3)
#
        for j in range(len(cross_population1)):
            all_population[population_num+j]=cross(cross_population1[j],cross_population2[j])
#            
        for j in range(len(mutate_population)):
            all_population[population_num+population_num2+j] = mutate(mutate_population[j])
#
        #all_population = np.concatenate([population,cross_children,mutate_children])
        #all_population = population
#
        evaluate(all_population,result)
        indexs = np.asarray(result).argsort()[-population_num:]
        all_population[:population_num] = all_population[indexs]
    evaluate(all_population[:population_num],result2)
    best_index = np.asarray(result2).argsort()[-1]
    best = np.asarray(all_population[:population_num])[np.asarray(result2).argsort()[-1]]
    best_score = result[np.asarray(result2).argsort()[-1]]
#
    print("best")
    print(best)
    print(best_score)

cpdef gpp(int population_num, int loop_num, float cross_rate, float mutate_rate):
    gp(population_num, loop_num, cross_rate, mutate_rate)
