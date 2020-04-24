import json
import networkx as nx
import matplotlib.pyplot as plt

with open('UK_cities.json', 'r') as f:
        uk_cities_dict = json.load(f)

uk_cities_graph = nx.Graph(uk_cities_dict)


from queue import PriorityQueue


def construct_path_from_root(node, root):
    """the non-recursive way!"""
    
    path_from_root = [node[0]]
    while node[1]:
        node = node[1]
        path_from_root = [node[0]] + path_from_root
    return path_from_root

def my_uniform_cost_graph_search(nxobject, initial, goal, compute_exploration_cost=False, stop_at_first_sol=True):
    
    if initial == goal: # just in case, because now we are checking the children
        return None
    
    number_of_explored_nodes = 1    
    frontier = PriorityQueue() 
    frontier.put([0, initial, None])  
    # FIFO queue should NOT be implemented with a list, this is slow! better to use deque
    explored = set()
    sol_found = False
    final_cost = float("inf")
    goal_node_found = None

    print('Frontier is: {}'.format(frontier.queue))
    print('Frontier len is: {}'.format(len(frontier.queue)))
    print('Explored nodes are: {}'.format(explored))
    
    while frontier.queue:
        frontier.queue.sort()
        print('Frontier is: {}'.format(frontier.queue))
        print('Frontier len is: {}'.format(len(frontier.queue)))

        node = frontier.get() # pop from the right of the list
        number_of_explored_nodes += 1
        explored.add(node[1])

        print('Explored nodes are: {}'.format(explored))
        print('Explored nodes len is: {}'.format(len(explored)))
        print('Current node is: {}'.format(node[1]))

        # So that we dont keep exploring when cumulative cost is higher than solution found
        if sol_found and node[0] > final_cost:
          return goal_node_found

        neighbours = nxobject.neighbors(node[1])

        for child_label in neighbours:
            
            child_weight = nxobject[node[1]][child_label]['weight']

            
            # cumulative cost
            child = [node[0] + child_weight, child_label, node[1::]]
            # Store solution info
            if child_label==goal:
                print('Found solution for {}:'.format(child))
                sol_found = True
                if child[0] < final_cost:
                  final_cost = child[0]
                  goal_node_found = child
                  
            if child_label not in explored:
              # Check if it's in frontier. If so, check if current path has less cost
              child_in_frontier = False
              for index, frontier_node in enumerate(frontier.queue):
                if child_label == frontier_node[1]:
                  if frontier_node[0] > child[0]:
                    frontier.queue[index] = child
                    frontier.queue.sort()

                  child_in_frontier = True
                  break

              if not child_in_frontier:
                if not sol_found or child[0] < final_cost:
                  frontier.put(child)

    if sol_found:
      return goal_node_found
    return None
