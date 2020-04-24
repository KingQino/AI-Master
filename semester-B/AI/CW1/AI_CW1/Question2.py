##!/usr/bin/python3
# -*- coding: utf-8 -*-
# @Author  : Yinghao Qin
# @Email   : y.qin@hss18.qmul.ac.uk
# @File    : Question2.pyx
# @Software: PyCharm
# Reference: 1. https://towardsdatascience.com/genetic-algorithm-implementation-in-python-5ab67bb124a6
#            2. https://data-flair.training/blogs/python-genetic-algorithms-ai/


from amnesiac import blurry_memory
import random
import numpy as np


# get all the possible characters of the passwords :('A'-'Z','0'-'9','_')
def get_gene_set():
    gene_Set = set()
    for p in range(48, 58):
        gene_Set.add(chr(p))
    for p in range(65, 91):
        gene_Set.add(chr(p))
    gene_Set.add(chr(95))
    return gene_Set


# randomly get an individual (password)
def gen_parent(length):
    genes = []
    while len(genes) < length:
        genes.extend(random.sample(geneSet, 1))
    return ''.join(genes)


# two given passwords (parents) crossover to generate new a pair of children
def crossover(parent1, parent2):
    chromosome_length = len(parent1)
    index = random.randrange(0, chromosome_length)
    children = [parent1[0:index]+(parent2[index:chromosome_length]),
                parent2[0:index]+(parent1[index:chromosome_length])]
    return children


# each individual do a mutation with a position of the genotype
def mutate(parent):
    index = random.randrange(0, len(parent))
    childGenes = list(parent)
    newGene, alternate = random.sample(geneSet, 2)
    if newGene == childGenes[index]:
        childGenes[index] = alternate
    else:
        childGenes[index] = newGene
    return ''.join(childGenes)


# get the fitness of the first password
def get_fitness_of_first_password(guess):
    fitness_ = blurry_memory([guess, "__________"], 190189237, 0)
    return fitness_[guess]


# get the fitness of the second password
def get_fitness_of_second_password(guess):
    fitness_ = blurry_memory(["__________", guess], 190189237, 1)
    return fitness_[guess]


##############################################
# Parameters
geneSet = get_gene_set()  # The element set of password: {'A' - 'Z', '0' - '9', '_'}
pwd_length = 10  # The length of the password
mutate_rate = 0.2  # The probability of mutation
population_size = 80  # The number of the initial population i.e. some random passwords are created to evolute
number_best_candidates = 20  # The number of best candidates which are selected from the population
number_offspring = 20  # For the best candidates, the number of their offspring
##############################################

##############################################
# 1. Initialization
##############################################
population = []
for i in range(population_size):
    individual = gen_parent(pwd_length)
    fitness = get_fitness_of_first_password(individual)
    population.append((individual, fitness))
##############################################

##############################################
# 2. Mating: contains - 1. selection, 2. crossover, 3. mutation
current_best_fitness = 0
reproductions_number_1 = 0
while current_best_fitness != 1:
    reproductions_number_1 += 1
    # Select elites from population
    population.sort(key=lambda x: x[1], reverse=True)
    current_best_fitness = population[0][1]
    bestCandidates = population[0:number_best_candidates]
    population.clear()
    population = bestCandidates[:]

    # Randomly select the two of these elites to mate (crossover)
    for i in range(number_offspring):
        candidate1, candidate2 = random.sample(bestCandidates, 2)
        offspring = crossover(candidate1[0], candidate2[0])
        fitness1, fitness2 = get_fitness_of_first_password(offspring[0]), get_fitness_of_first_password(offspring[1])
        population.append((offspring[0], fitness1))
        population.append((offspring[1], fitness2))

    # Each of the population has a probability to mutate
    for i in range(len(population)):
        if random.random() < mutate_rate:
            candidate = mutate(population[i][0])
            fitness = get_fitness_of_first_password(candidate)
            population.append((candidate, fitness))

print("The first password is  "+str(population[0]))
print("And "+str(reproductions_number_1)+" times reproductions to converge.")
##############################################

# To find the second password (repeat the operations above again)
##############################################
# 1. Initialization
##############################################
population.clear()
for i in range(population_size):
    individual = gen_parent(pwd_length)
    fitness = get_fitness_of_second_password(individual)
    population.append((individual, fitness))
##############################################

##############################################
# 2. Mating: contains - 1. selection, 2. crossover, 3. mutation
current_best_fitness = 0
reproductions_number_2 = 0
while current_best_fitness != 1:
    reproductions_number_2 += 1
    # Select elites from population
    population.sort(key=lambda x: x[1], reverse=True)
    current_best_fitness = population[0][1]
    bestCandidates = population[0:number_best_candidates]
    population.clear()
    population = bestCandidates[:]

    # Randomly select the two of these elites to mate (crossover)
    for i in range(number_offspring):
        candidate1, candidate2 = random.sample(bestCandidates, 2)
        offspring = crossover(candidate1[0], candidate2[0])
        fitness1, fitness2 = get_fitness_of_second_password(offspring[0]), get_fitness_of_second_password(offspring[1])
        population.append((offspring[0], fitness1))
        population.append((offspring[1], fitness2))

    # Each of the population has a probability to mutate
    for i in range(len(population)):
        if random.random() < mutate_rate:
            candidate = mutate(population[i][0])
            fitness = get_fitness_of_second_password(candidate)
            population.append((candidate, fitness))

print("The second password is "+str(population[0]))
print("And "+str(reproductions_number_2)+" times reproductions to converge.")
##############################################


##############################################
# For Test
##############################################
print("--------------------------------------------")
print("-------------------TEST---------------------")
print("--------------------------------------------")
print("Run the code 100 times.")
list_reproduction_number_1 = []
for k in range(100):
    population.clear()
    for i in range(population_size):
        individual = gen_parent(pwd_length)
        fitness = get_fitness_of_first_password(individual)
        population.append((individual, fitness))

    current_best_fitness = 0
    reproductions_number_1 = 0
    while current_best_fitness != 1:
        reproductions_number_1 += 1
        # Select elites from population
        population.sort(key=lambda x: x[1], reverse=True)
        current_best_fitness = population[0][1]
        bestCandidates = population[0:number_best_candidates]
        population.clear()
        population = bestCandidates[:]

        # Randomly select the two of these elites to mate (crossover)
        for i in range(number_offspring):
            candidate1, candidate2 = random.sample(bestCandidates, 2)
            offspring = crossover(candidate1[0], candidate2[0])
            fitness1, fitness2 = get_fitness_of_first_password(offspring[0]), get_fitness_of_first_password(
                offspring[1])
            population.append((offspring[0], fitness1))
            population.append((offspring[1], fitness2))

        # Each of the population has a probability to mutate
        for i in range(len(population)):
            if random.random() < mutate_rate:
                candidate = mutate(population[i][0])
                fitness = get_fitness_of_first_password(candidate)
                population.append((candidate, fitness))

    list_reproduction_number_1.append(reproductions_number_1)

average_1 = np.mean(list_reproduction_number_1)
variance_1 = np.var(list_reproduction_number_1)
print("The averaged number of reproductions (the first password): "+str(average_1))
print("The variance of reproduction number (the first password) : "+str(variance_1))

list_reproduction_number_2 = []
for k in range(100):
    population.clear()
    for i in range(population_size):
        individual = gen_parent(pwd_length)
        fitness = get_fitness_of_second_password(individual)
        population.append((individual, fitness))

    current_best_fitness = 0
    reproductions_number_2 = 0
    while current_best_fitness != 1:
        reproductions_number_2 += 1
        # Select elites from population
        population.sort(key=lambda x: x[1], reverse=True)
        current_best_fitness = population[0][1]
        bestCandidates = population[0:number_best_candidates]
        population.clear()
        population = bestCandidates[:]

        # Randomly select the two of these elites to mate (crossover)
        for i in range(number_offspring):
            candidate1, candidate2 = random.sample(bestCandidates, 2)
            offspring = crossover(candidate1[0], candidate2[0])
            fitness1, fitness2 = get_fitness_of_second_password(offspring[0]), get_fitness_of_second_password(
                offspring[1])
            population.append((offspring[0], fitness1))
            population.append((offspring[1], fitness2))

        # Each of the population has a probability to mutate
        for i in range(len(population)):
            if random.random() < mutate_rate:
                candidate = mutate(population[i][0])
                fitness = get_fitness_of_second_password(candidate)
                population.append((candidate, fitness))

    list_reproduction_number_2.append(reproductions_number_2)

average_2 = np.mean(list_reproduction_number_2)
variance_2 = np.var(list_reproduction_number_2)
print("The averaged number of reproductions (the second password): "+str(average_2))
print("The variance of reproduction number (the second password) : "+str(variance_2))
