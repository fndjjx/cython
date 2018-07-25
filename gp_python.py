import numpy as np

target = [0]*300
target = [1 if np.random.uniform(0,1)>0.6 else 0 for i in target]
target = np.array(target)
print("target")
print(target)

class GP():
    def __init__(self, individual, population_num, metric, length):
        self.population = []
        for i in range(population_num):
            self.population.append(individual(length))
        self.metric = metric
        self.result = []
        self.length = length
        self.population_num = population_num

    def _cross(self, inds):
        return inds[0].cross(inds[1])

    def _mutate(self, ind):
        return ind.mutate()

    #def _evaluate(self):
    #    return np.array(list(map(self.metric, self.population)))
    def _evaluate(self):
        result = []
        for i in self.population:
            result.append(self.metric(i))
        return np.array(result)

    def _select_mutate(self, rate):
        self.population = np.array(self.population)
        return self.population[np.random.uniform(0,1,len(self.population))<rate]

    def _select_cross(self, rate):
        #p = []
        #for i in range(int(len(self.population)*rate)):
        #    pair = [int(i) for i in np.random.uniform(0,len(self.population),2)]
        #    p.append([self.population[pair[0]], self.population[pair[1]]])
        #return p
        self.population = np.array(self.population)
        p1_index,p2_index = np.random.uniform(0,self.population_num-1,[2,int(len(self.population)*rate)]).astype(int)
        return zip(self.population[p1_index],self.population[p2_index])


    def run(self, loop_num, cross_rate, mutate_rate):
        for i in range(loop_num):
            cross_population = self._select_cross(cross_rate)
            mutate_population = self._select_mutate(mutate_rate)
            self.population = list(self.population)
            for ind in cross_population:
                self.population.append(self._cross(ind))
            for ind in mutate_population:
                self.population.append(self._mutate(ind))
            score = self._evaluate()
            self.population = np.array(self.population)
            self.population = list(self.population[score.argsort()[-self.population_num:]])
#            self.population = self.population[-self.population_num:]
        for i in self.population:
            self.result.append([i,self.metric(i)])
        self.result.sort(key=lambda x:x[1])

    def show(self):
        print("best")
        print(self.result[-1][0])
        print(self.result[-1][1])

class Ind():
    def __init__(self, length, chromosome=None):
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

def metric(ind):

    return -np.sum((ind.chromosome-target)**2)

def metric3(ind):

    return 0

def metric2(ind):
    result = 0
    for i in range(len(target)):
        result -= (target[i]-ind.chromosome[i])**2
    return result



if __name__=="__main__":
    import time
    s = time.time()
    gp = GP(Ind,1000,metric, 300)
    gp.run(1000,0.8,0.8)
    gp.show()
    e = time.time()
    print(e-s)
