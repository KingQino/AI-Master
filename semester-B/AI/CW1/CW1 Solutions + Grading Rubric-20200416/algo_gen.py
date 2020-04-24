import numpy as np
import random
import string
import copy
from amnesiac import blurry_memory

class GeneticPasswordCracker(object):
    """
    Allows to find a forgotten password for the AI module.
    """
    def __init__(self, omega, student_number, password_index = 1, popSize = 100, genomLen = 10, selecStrat = "Number", selecArg = 10,
        pMuta = 0.05, pCO = 0.1):
        self.omega = omega
        self.student_number = student_number
        self.password_index = password_index
        self.omegaLen = len(omega)
        self.popSize = popSize
        self.genomLen = genomLen
        self.pMuta = pMuta
        self.pCO = pCO
        self.pop = self.initialize_pop()
        if selecStrat == "Number":
            if selecArg < 1 or type(selecArg) == float:
                print("With given initialization parameters, selecArg must be a positive integer.",
                    " Therefore selecArg is set to 10.")
                self.nbSelected = 10
            else:
                self.nbSelected = selecArg
        else:
            if selecArg < 0 or selecArg > 1 or type(selecArg) == int:
                print("With given initialization parameters, selecArg must be a float between 0 and 1.",
                    "Therefore selecArg is set to 0.2.")
                self.nbSelected = np.ceil(popSize * 0.2)
            else:
                self.nbSelected = np.ceil(popSize * selecArg)

        self.currentFitness = self.get_fitness(self.pop)
        self.meanFitness = [np.mean(list(self.currentFitness.values()))]
        self.maxFitness = [max(self.currentFitness.values())]
        self.minFitness = [min(self.currentFitness.values())]


    def initialize_pop(self):
        """
        Initializes a population with respect to the universal set omega of size popSize and length genomLen.
        :return: A list of randomly generated individuals
        :rtype : List of string
        """
        # Randomly generates popSize strings of size genomLen with the given alphabet omega.
        return [''.join([random.choice(self.omega) for _ in range(self.genomLen)]) for _ in range(self.popSize)]

    def get_fitness(self, population):
        """
        Calls the executable to compute fitness of each individuals of population
        :param population: Population for which fitness must be computed
        :type population: List of individuals (so string)
        :return: Dictionary with individuals as keys and values are fitness
        :rtype: Dictionary
        """
        return blurry_memory(population, self.student_number, self.password_index)


    def select_indiv(self):
        """
        Returns the list of the best indivuals based on their fitness. The length of this list corresponds to the number
        of individuals selected with respect to the selection criteria from the initialization.
        :return: List of individuals with the higher fitness
        :rtype: List of string
        """
        # We sort all the population by decreasing fitness and we take the first nbSelected.
        sortedIndiv = sorted(self.currentFitness, key=self.currentFitness.get, reverse = True)
        return sortedIndiv[:self.nbSelected]


    def mutation(self, generating = False, pMuta = 0.5):
        """
        Mutate selected individuals either for evolution reason or for population generation.
        :param generating: States if the mutation has a generation purpose or not (default False)
        :type generating: Boolean
        :param pMuta: Probability of mutation in case of population generation (default 0.5)
        :type pMuta : Float
        """
        # Creates a list of the universal set to use slice after
        omegaList = list(self.omega)
        # Creates the list containing mutants
        mutant = []
        # If we generate new individuals from the already existing mutant we first compute the new fitness of mutant
        # and we compute how much mutant we must create (popSize - already mutant)
        if generating:
            nbToGenerate = self.popSize - self.nbSelected
            pMuta = pMuta
            self.currentFitness = self.get_fitness(self.selecIndiv)
        # Otherwise we just mutate the selected ones with the pMuta given at class initialization
        else:
            pMuta = self.pMuta
            nbToGenerate = self.nbSelected

        # Here we create a list containing the semi range from which we will randomly pick the new element of omega
        # for each selected individual
        # This idea comes from that a mutant with a fitness close to 1 should not have a big change when mutation occurs
        # to avoid diverging.
        rangesToMutation = [12 if self.currentFitness[fit] < 0.2 else (8 if self.currentFitness[fit] < 0.5 else
            (4 if self.currentFitness[fit] < 0.8 else 2)) for fit in self.selecIndiv]

        # Counter to know how many mutant we generated
        nbGenerated = 0
        # Repeat until we have the good number of mutant
        while nbGenerated < nbToGenerate:
            # Compute the index of the proper individual to make mutant
            selectedIndex = nbGenerated % self.nbSelected
            # Create a list instead of a string in order to modify its composition
            indiv = list(self.selecIndiv[selectedIndex])
            # For each position in the genom we see if the position must mutate or not
            for pos in range(self.genomLen):
                if np.random.rand() <= pMuta:
                    # If it's the case, we first have to find the character in omega and we then take the good range.
                    # First we must make sure that we have joint torique conditions.
                    charIdx = self.omega.find(indiv[pos])
                    if charIdx - rangesToMutation[selectedIndex] < 0:
                        born1 = self.omegaLen + charIdx - rangesToMutation[selectedIndex]
                    else:
                        born1 = charIdx - rangesToMutation[selectedIndex]

                    if charIdx + rangesToMutation[selectedIndex] > self.omegaLen:
                        born2 = rangesToMutation[selectedIndex] - (self.omegaLen - charIdx)
                    else:
                        born2 = charIdx + rangesToMutation[selectedIndex]

                    minBorn, maxBorn = min(born1, born2), max(born1, born2)
                    # Randomly choose an element in omega in the given range
                    indiv[pos] = np.random.choice(omegaList[minBorn : maxBorn])
            # Then we just add the mutant in string
            mutant += ["".join(indiv)]
            nbGenerated += 1

        # If we are generating, we add these new mutants to the already existing mutant
        if generating:
            self.pop = self.selecIndiv + mutant
        # Otherwise we replace the selected one by mutants
        else:
            self.selecIndiv = mutant


    def crossing_over(self):
        """
        Applies crossing over on the selected individuals with a probability pCO
        """
        for index, indiv in enumerate(self.selecIndiv):
            # Transformation into a list to use slicing
            indiv = list(indiv)
            # If crossing over should be applied on this individual
            if np.random.rand() <= self.pCO:
                # We get the list of all the other selected individuals
                others = self.selecIndiv[:]
                others.remove("".join(indiv))
                # We pick randomly one of them
                other = np.random.choice(others)
                # We get its index in order to modify directly it (not a buffer variable)
                otherIdx = self.selecIndiv.index(other)
                # transforms it into a list
                other = list(other)
                # Randomly choose a starting point and then we swith starting from that position the genom between the
                # two individuals
                startingIdx = np.random.choice(range(self.genomLen))
                tempChange = indiv[startingIdx:]
                indiv[startingIdx:] = other[startingIdx:]
                other[startingIdx:] = tempChange
                # Modification of the new one
                self.selecIndiv[otherIdx] = "".join(other)

            self.selecIndiv[index] = "".join(indiv)



    def run_epoch(self, getStatistics = True):
        """
        Performs an iteration of our genetic algorithm (selection, mutation, crossing over and population generation)
        """
        self.selecIndiv = self.select_indiv()
        self.mutation()
        self.crossing_over()
        self.mutation(generating = True)
        self.currentFitness = self.get_fitness(self.pop)
        if getStatistics:
            self.meanFitness += [np.mean(list(self.currentFitness.values()))]
            self.maxFitness += [max(self.currentFitness.values())]
            self.minFitness += [min(self.currentFitness.values())]


    def run(self):
        """
        Runs genetic algorithm until convergence
        """
        counter = 1
        # Won't stop until we find the perfect password
        while 1.0 not in self.currentFitness.values():
            self.run_epoch()
            counter += 1
        print("Password {} of student {} is {} and found in {} iterations".format(self.password_index, self.student_number, sorted(self.currentFitness, key=self.currentFitness.get, reverse = True)[0], counter))


    def get_statistics_about_convergence(self, nbTimes = 10):
        """
        Print some statistics about convergence computed on nbTimes execution
        :param nbTimes: Number of texecution on which we will compute the statistics. By default 10
        :type nbTimes: 10
        """
        # List to gather the number of iteration before convergence
        counters = []
        for time in range(nbTimes):
            # reinitialize population
            self.pop = self.initialize_pop()
            self.currentFitness = self.get_fitness(self.pop)
            counter = 1
            while 1:
                self.run_epoch(getStatistics = False)
                counter += 1
                if 1.0 in list(self.currentFitness.values()):
                    break
            counters += [counter]
        # Print and compute statistics
        print("====== COMPUTED ON {0} EXECUTION ======".format(nbTimes))
        print("mean number of generation to converge is {0:.3f}".format(np.mean(counters)))
        print("median number of generation to converge is {0:.3f}".format(np.median(counters)))
        print("min number of generation to converge is {0:.3f}".format(np.min(counters)))
        print("max number of generation to converge is {0:.3f}".format(np.max(counters)))
        print("standard deviation of generation to converge is {0:.3f}".format(np.std(counters)))


if __name__ == "__main__":
	# Change the student number to run it
    passCrack = GeneticPasswordCracker(omega = string.digits + string.ascii_uppercase  + "_", student_number = 000000000)
    # These two lines run until convergence and save the corresponding dynamique
    passCrack.run()
    # This one compute statistics about convergence
    passCrack.get_statistics_about_convergence()
