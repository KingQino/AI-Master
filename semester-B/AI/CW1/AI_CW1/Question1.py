# -*- coding: utf-8 -*-
# @Time    : 2020/3/9 8:14 PM
# @Author  : Yinghao Qin
# @Email   : y.qin@hss18.qmul.ac.uk
# @File    : Question1.pyx
# @Software: PyCharm


import networkx as nx
import matplotlib.pyplot as plt
import json
import numpy as np


# The load of graph files, provided by the tutorial
def load_graph_from_file(filename):
    with open(filename) as labyrinth_file:
        dict_labyrinth = json.load(labyrinth_file)
        return nx.Graph(dict_labyrinth)


# display the graph， provided by the tutorial
def show_weighted_graph(networkx_graph, node_size, font_size, fig_size):
    # Allocate the given fig_size in order to have space for each node
    plt.figure(num=None, figsize=fig_size, dpi=80)
    plt.axis('off')
    # Compute the position of each vertex in order to display it nicely
    nodes_position = nx.spring_layout(networkx_graph)
    # You can change the different layouts depending on your graph
    # Extract the weights corresponding to each edge in the graph
    edges_weights = nx.get_edge_attributes(networkx_graph, 'weight')
    # Draw the nodes (you can change the color)
    nx.draw_networkx_nodes(networkx_graph, nodes_position, node_size=node_size,
                           node_color=["orange"] * networkx_graph.number_of_nodes())
    # Draw only the edges
    nx.draw_networkx_edges(networkx_graph, nodes_position,
                           edgelist=list(networkx_graph.edges), width=2)
    # Add the weights
    nx.draw_networkx_edge_labels(networkx_graph, nodes_position,
                                 edge_labels=edges_weights)
    # Add the labels of the nodes
    nx.draw_networkx_labels(networkx_graph, nodes_position, font_size=font_size,
                            font_family='sans-serif')
    plt.axis('off')
    plt.show()


def uniform_cost_search(nx_graph, start, goal):
    node = (start, 0, [start])
    frontier = [node]
    explored = set()

    is_loop = True
    while is_loop:
        frontier.sort(key=lambda x: x[1])
        print("frontier = " + str(frontier))
        print("explored = " + str(explored))
        if len(frontier) == 0:
            return "failure"
        node = frontier.pop(0)
        if node[0] == goal:
            return node[2]
        explored.add(node[0])

        neighbors = nx_graph.neighbors(node[0])
        for neighbor in neighbors:
            cost = nx_graph.get_edge_data(node[0], neighbor)['weight']
            temp_node = list(node[2])
            temp_node.append(neighbor)
            child_node = (neighbor, node[1] + cost, temp_node)

            frontier_states = [a_tuple[0] for a_tuple in frontier]
            if (child_node[0] not in explored) and (child_node[0] not in frontier_states):
                frontier.append(child_node)
            elif child_node[0] in frontier_states:
                index = [frontier.index(a_tuple) for a_tuple in frontier if a_tuple[0] == child_node[0]]
                index = index[0]
                if child_node[1] < frontier[index][1]:
                    frontier[index] = child_node

    return "failure"


# the function is used to solve the question d
def ucs_d(nx_graph, start, goal):
    # parameters
    max_speed = 300
    rent_fee = 100
    fine = 1000

    node = (start, 0, [start])
    frontier = [node]
    explored = set()

    is_loop = True
    while is_loop:
        frontier.sort(key=lambda x: x[1])
        if len(frontier) == 0:
            return "failure"
        node = frontier.pop(0)
        if node[0] == goal:
            return node[2], node[1]
        explored.add(node[0])

        neighbors = nx_graph.neighbors(node[0])
        for neighbor in neighbors:
            distance = nx_graph.get_edge_data(node[0], neighbor)['weight']
            velocity_limit = nx_graph.get_edge_data(node[0], neighbor)['weight']
            min_cost = 999999
            for velocity in range(1, max_speed + 1):
                if velocity <= velocity_limit:
                    cost = rent_fee * (distance/velocity)
                else:
                    cost = rent_fee * (distance/velocity) + fine * (1 - np.exp(velocity_limit - velocity))
                if cost < min_cost:
                    min_cost = cost
            tep_node = list(node[2])
            tep_node.append(neighbor)
            child_node = (neighbor, node[1] + min_cost, tep_node)

            frontier_states = [a_tuple[0] for a_tuple in frontier]
            if (child_node[0] not in explored) and (child_node[0] not in frontier_states):
                frontier.append(child_node)
            elif child_node[0] in frontier_states:
                index = [frontier.index(a_tuple) for a_tuple in frontier if a_tuple[0] == child_node[0]]
                index = index[0]
                if child_node[1] < frontier[index][1]:
                    frontier[index] = child_node

    return "failure"


UK_cities = load_graph_from_file("UK_cities.json")
result = uniform_cost_search(UK_cities, 'london', 'aberdeen')
print(result)
print("##################################################")
print("################ Question (d) ####################")
result_d_path, cost_bonus = ucs_d(UK_cities, 'london', 'aberdeen')
print(result_d_path)
print(cost_bonus)
