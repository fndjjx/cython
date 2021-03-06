import numpy as np
cimport numpy as np

length = 300

cdef np.ndarray target
target = np.zeros(length)
target[np.random.uniform(0,1,length)>0.6]=1

print("target")
print(target)


cdef np.ndarray cross(np.ndarray ch1,np.ndarray ch2):
    cdef int index
    index = int(np.random.uniform(0,length))
    return np.concatenate([ch1[:index],ch2[index:]])

cdef np.ndarray mutate(np.ndarray ch):
    cdef int index
    index = int(np.random.uniform(0,length))
    if ch[index]>0:
        ch[index]=0
    else:
        ch[index]=1
    return ch

cdef init_chromosome(int length):
    cdef np.ndarray chromosome 
    chromosome = np.zeros(length)
    chromosome[np.random.uniform(0,1,length)>0.6]=1
    return chromosome

cdef double metric(np.ndarray ch):
    return -np.sum((ch-target)**2)

cdef evaluate(np.ndarray[:] population, double[:] result):
    #cdef int r=len(population)
    #cdef double[:] result = np.empty(r,dtype=np.double)
    for i in range(len(result)):
        result[i] = metric(population[i])
    #return result

         
cdef select_mutate(np.ndarray[:] population, float rate, np.ndarray[:] p1):
    #cdef int r1=int(len(population)*rate)
    #cdef int r2=length
    #cdef int index
    #cdef np.ndarray[:] p1 = np.empty(r1, dtype=np.ndarray)
    for i in range(len(p1)):
        index = int(np.random.uniform(0,len(population),1))
        p1[i] = population[index]
    
    #return p1



cdef select_cross(np.ndarray[:] population, float rate, np.ndarray[:] p1, np.ndarray[:] p2):
    #cdef int r1=int(len(population)*rate)
    #cdef int r2=length
    #cdef np.ndarray[:] p1 = np.empty(r1, dtype=np.ndarray)
    #cdef np.ndarray[:] p2 = np.empty(r1, dtype=np.ndarray)

    for i in range(len(p1)):
        pair = [int(j) for j in np.random.uniform(0,len(population),2)]
        p1[i] = population[pair[0]]
        p2[i] = population[pair[1]]
    #return p1,p2



cpdef gp(int population_num, int loop_num, float cross_rate, float mutate_rate):
    cdef int population_num1 = population_num
    cdef int population_num2 = int(population_num*cross_rate)
    cdef int population_num3 = int(population_num*mutate_rate)
    cdef int population_num4 = population_num1+population_num2+population_num3
    cdef np.ndarray[:] population=np.empty(population_num1,dtype=np.ndarray)
    cdef np.ndarray[:] all_population=np.empty(population_num4,dtype=np.ndarray)
    cdef np.ndarray[:] cross_population1=np.empty(population_num2,dtype=np.ndarray)
    cdef np.ndarray[:] cross_population2=np.empty(population_num2,dtype=np.ndarray)
    cdef np.ndarray[:] cross_children=np.empty(population_num2,dtype=np.ndarray)
    cdef np.ndarray[:] mutate_population=np.empty(population_num3,dtype=np.ndarray)
    cdef np.ndarray[:] mutate_children=np.empty(population_num3,dtype=np.ndarray)
    cdef double[:] result=np.empty(population_num4,dtype=np.double)
    cdef double[:] result2=np.empty(population_num,dtype=np.double)
    #cdef np.ndarray all_population[population_num+int(population_num*cross_rate)+int(population_num*mutate_rate)]
    #cdef np.ndarray cross_population1[int(population_num*cross_rate)]
    #cdef np.ndarray cross_population2[int(population_num*cross_rate)]
    #cdef np.ndarray cross_children[int(population_num*cross_rate)]
    #cdef np.ndarray mutate_population[int(population_num*mutate_rate)]
    #cdef np.ndarray mutate_children[int(population_num*mutate_rate)]
    #cdef np.ndarray result[population_num]

    for i in range(population_num):
        population[i] = init_chromosome(length)

    for i in range(loop_num):
        select_cross(population, cross_rate, cross_population1, cross_population2)
        select_mutate(population, mutate_rate,mutate_population)

        for j in range(len(cross_population1)):
            cross_children[j] = cross(cross_population1[j],cross_population2[j])
            
        for j in range(len(mutate_population)):
            mutate_children[j] = mutate(mutate_population[j])

        all_population = np.concatenate([population,cross_children,mutate_children])
        #all_population = np.concatenate([population,cross_children])
        #all_population = np.concatenate([population])

        #score = evaluate(np.asarray(all_population))
        evaluate(all_population,result)
        indexs = np.asarray(result).argsort()[-population_num:]
        population = np.asarray(all_population)[indexs]
    #for i in range(len(population)):
    #    result[i] = metric(population[i])
    evaluate(population,result2)
    best_index = np.asarray(result2).argsort()[-1]
    best = np.asarray(population)[np.asarray(result2).argsort()[-1]]
    best_score = result[np.asarray(result2).argsort()[-1]]

    print("best")
    print(best)
    print(best_score)

