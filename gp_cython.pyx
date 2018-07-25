import numpy as np
cimport numpy as np
from cpython.ref cimport PyObject

target = [0]*300
target = [1 if np.random.uniform(0,1)>0.6 else 0 for i in target]
target = np.array(target)
print("target")
print(target)
cdef class Ind():
        def __cinit__(self, length, chromosome=None):
            if not isinstance(chromosome,np.ndarray):
                self.chromosome = [0]*length
                self.chromosome = [1 if np.random.uniform(0,1)>0.6 else 0 for i in self.chromosome]
                self.chromosome = np.array(self.chromosome)

            else:
                self.chromosome = chromosome
            self.length = length

        def cross(self, other):
            index = int(np.random.uniform(0,self.length))
            return Ind(self.length,np.concatenate([self.chromosome[:index],other.chromosome[index:]]))

        def mutate(self):
            index = int(np.random.uniform(0,self.length))
            if self.chromosome[index]>0:
                self.chromosome[index]=0
            else:
                self.chromosome[index]=1
            return Ind(self.length, self.chromosome)

        def __str__(self):
            return str(self.chromosome)



cdef class GP():
        cdef int length
        cdef PyObject *population[100]

        def __init__(self, individual, population_num, metric, length):
            cdef object temp_object
            for i in range(population_num):
                temp_object = individual(length)
                self.population[i]=<PyObject*>temp_object
            self.metric = metric
            self.result = []
            self.length = length
            self.population_num = population_num
              

        cdef _cross(self, inds):
            return inds[0].cross(inds[1])

        cdef _mutate(self, ind):
            return ind.mutate()

        cdef _evaluate(self, cross_children,mutate_children):
            result = []
            for i in self.population:
                result.append(self.metric(<object>i))
            for i in cross_children:
                result.append(self.metric(<object>i))
            for i in mutate_children:
                result.append(self.metric(<object>i))
            return np.array(result)

        cdef _select_mutate(self, rate):
            p = []
            for i in range(int(self.population_num*rate)):
                index = int(np.random.uniform(0,self.population_num))
                p.append(<object>self.population[index])
            return p


        cdef _select_cross(self, rate):
            p = []
            for i in range(int(self.population_num*rate)):
                pair = [int(i) for i in np.random.uniform(0,self.population_num,2)]
                p.append([<object>self.population[pair[0]], <object>self.population[pair[1]]])
            return p

        cdef run(self, loop_num, cross_rate, mutate_rate):
            for i in range(loop_num):
                cross_population = self._select_cross(cross_rate)
                mutate_population = self._select_mutate(mutate_rate)
                #cdef PyObject *cross_children[len(cross_population)]
                #cdef PyObject *mutate_children[len(mutate_population)]
                cross_children = [0]*len(cross_population)
                mutate_children = [0]*len(mutate_population)
                for j in range(len(cross_population)):
                    cross_children[j] = self._cross(cross_population[j])
                for j in range(len(mutate_population)):
                    mutate_children[j] = self._mutate(mutate_population[j])
                score = self._evaluate(cross_children,mutate_children)
    #            self.population = np.array(self.population)
                selected_index = score.argsort()[-self.length:]
                population = [0]*len(selected_index)
                for j in range(len(selected_index)):
                    population[j] = <object>self.population[selected_index[j]]
                for j in range(self.population_num):
                    if j<len(selected_index):
                        self.population[j] = <PyObject*>population[j]

            for i in range(len(self.population_num)):
                self.result.append([<object>self.population[i],self.metric(<object>self.population[i])])
            self.result.sort(key=lambda x:x[1])

        def show(self):
            print("best")
            print(self.result[-1][0])
            print(self.result[-1][1])


def metric(ind):

    return -sum((ind.chromosome-target)**2)



if __name__=="__main__":
    import time
    s = time.time()
    gp = GP(Ind,100,metric, 300)
    gp.run(100,0.8,0.8)
    gp.show()
    e = time.time()
    print(e-s)
