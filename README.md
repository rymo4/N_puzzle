# The N Puzzle Problem 
### and Using Search Algorithms for Problem Solving

Generalized search algorithms for problem solving in Ruby, by Ryder Moody. In all tests, N = 15.

IMPORTANT: Please view the formatted version at https://gist.github.com/rymo4/cafdbe489f4534105ead

## What's the N Puzzle Problem?

A solved N=8 Puzzle Problem looks like this:

```
-------------
|   | 1 | 2 |
-------------
| 3 | 4 | 5 |
-------------
| 6 | 7 | 8 |
-------------
```

The goal is to start with mixed up tiles, and find a way (hopefully the shortest) to get them into the ideal position. A solution is a sequence of moves (N, S, E, or W) to move the blank is such a way that the problem is solved.

## Running It

```bash
$ ruby search_test.rb [start state] [goal state]
```

Where each param is a lisp style list of tiles, followed by the position of the blank (also denoted by a 0 in the list). For example, here is the easy (3 moves) test case:

```bash
$ ruby search_test.rb "( (1 2 3 0) (4 5 6 7) (8 9 10 11) (12 13 14 15) (0 3) )" "( (0 1 2 3) (4 5 6 7) (8 9 10 11) (12 13 14 15) (0 0) )"
```

For convienence, the easy, medium, and hard test cases are listed at the top of the `search_test.rb` file.

You will see all the stats printed to command line.

IMPORTANT: For hard tests, set the `doing_hard_example` boolean to `true`, otherwise you will use all your memory, overflow your stack, and/or waste all your time. This skips: BFS, IDS, and Uniform Search.

## The Algorithms

1. Depth First Search
2. Breadth First Search
3. Depth Limited Search
4. Iterative Deepening Depth Limited Search
5. Uniform Cost Search
6. Greedy Search
7. A\* Search

All algorithms track the following statistics:

1. Number of nodes visted
2. Number of nodes left on the open list at termination
3. Number of nodes left on the closed list at termination (if there is one)
4. Number of nodes generated that have been seen before

While this slows down the algorithms significantly, they provide very useful insight.

## The Nodes

All the algorithms are generaralized so that they can work on any kind of node. I happen to be testing them on a complex `PuzzleNode`, but they work just the same with any class that follows these properties:

1. Any method to output an array of children nodes.
2. `value` method/attribute which displays its value.
3. Overridden and meaningful `==` method. Usually this will just be that their values are the same.
4. `g_hat` public attribute (if using heuristic based searches)
5. `h_hat` method which is the best guess at how close it is to a solution (if using heuristic based searches).

Here is a simple (and somewhat meaningless) `Node` defintion that would work with all algorithms:

```ruby
class Node < Struct.new(:value, :children)
  attr_accessor :g_hat
  def initialize *args
    @g_hat = 1
    super
  end
  def h_hat
    @value
  end
  def == other
    @value == other.value
  end
end
```

A searchable tree could be made from these like this:

```ruby
start_state = Node.new(5, [
  Node.new(10, [
    Node.new(-12, [])]),
  Node.new(27, [
    Node.new(9, [
      Node.new(13, [
        Node.new(19, [])
      ]),
      Node.new(11, [])
    ])
  ])
])
```

This representation could be used for n-ary tree or graph traversal. For a more meaningful `h_hat` function, the node probably needs to know what the goal looks like. See `PuzzleNode` for details.

## Heuristics

Heuristics play an important role in the smart search algorithms. They provide a best guess at the cost (or number of turns) to get to the goal node. Thus, it makes sense that the more you know about the goal node and the progression of nodes to get there, the better these searches will perform. I used the following two heuristics:

### Manhattan Distance

The sum of Manhattan distances between each node and it's position in the goal state. This provided a huge performance boost over "dumb" heuristics.

### Manhattan Distance Plus Penalty

The Manhattan distance sum, but plus a penalty everytime a two nodes in the same row need to be swapped to get into a solution state. This takes an extra 2 moves, so the penalty is two per pair of nodes. This provided a slight edge over Manhattan distance alone in terms of number of nods visted, but took longer because of the increased complexity of the `h_hat` function. Write your nodes in optimized C for best results.

## Other Performance Hacks

Specificly I found two great speed boosts:

1. Prune by preventing the generation of the state that you just came from. This decreases the branching factor by 1, which is very significantly when the maximum is 4 (N, S, E, W).
2. Shuffle the generated children states. This randomness significantly helps some searches by making the time taken for a length N search more consistent. Since they would otherwise be explored in the same order, some solutions might be hit very quickly, but others might take much longer.

## Performance Analysis

Below are some crude but insightful benchmarks of the search algorithms. Each box with a number indicates that this search produced a solution, and that the solution was optimal. Since some algorithms benefit more from certain tweaks, only the applicable algorithms are shown.

Note: None of these benchmarks are averaged in any way, so take them with a grain of salt. That being said, the times were very consistent.

### Pruning vs. Not Pruning

Heuristic: MM, Ruby Implementation: MRI 1.9.3

#### Time:

|            | Easy        | Medium      | Hard |
|------------|-------------|------------|-----------------|
| BFS (NP)     | 0.000561s  | 2.632327s | N/A |
| BFS (P)     |  0.000773s | 2.969879s | N/A |
| IDS (NP)     | 0.005269s | 1.402275s | N/A |
| IDS (P)     | 0.003516s | 0.108599s | N/A |
| Greedy (NP) | 0.000667s  | 0.002381s  | 138.040255s |
| Greedy (P)  |  0.000572s | 0.00265s  | 95.601541s |
| A* (NP)     | 0.000653s  | 0.002476s | 2.979499s |
| A* (P)      |  0.000572s | 0.002624s | 2.182345s |

#### Number of nodes visited:

|            | Easy        | Medium      | Hard |
|------------|-------------|------------|-----------------|
| BFS (NP)    |  8 | 853 | Way too many |
| BFS (P)     | 11 | 1080 | Way too many |
| IDS (NP)    |  170 | 68863  | Way too many |
| IDS (P)     |  91 | 4604 | Way too many |
| Greedy (NP) | 8  | 34  | 19086 |
| Greedy (P)  | 6 | 24 | 12718 |
| A* (NP)     | 4  | 12 | 925 |
| A* (P)      | 4 | 13 | 911 |

There are a few numbers that get slightly worse with pruning, but this is probably due to a combination of a slightly increased compututation from the extra check, and (mostly) the randomness of shuffling the generated states. Most stats for medium and hard puzzles get much better, as expected.

Since BFS is exponential in space, the could not complete the hard test. Likewise, IDS had trouble with the hard test.

### Manhattan vs. Modified Manhattan

Settings: Pruning: true, Ruby Implementation: MRI 1.9.3

#### Time:

|            | Easy        | Medium      | Hard |
|------------|-------------|------------|-----------------|
| Greedy (M)  |   0.000547s   |  0.002136s  |  136.18932s  |
| Greedy (MM) |   0.000643s   |  0.00211s |  105.459306s |
| A* (M)      |   0.000483s   |  0.002077s  |   2.929437s  |
| A* (MM)     |   0.000610s   |  0.00297s   |  2.44413s    |

#### Number of nodes visited:

|            | Easy        | Medium      | Hard |
|------------|-------------|------------|-----------------|
| Greedy (M)  |   6   |  25  |  15946  |
| Greedy (MM) |   6  |    22        |  14368  |
| A* (M)      |  4  |     12     |  1016   |
| A* (MM)     |  4  |     13     |  937    |

As you can see, on easy puzzles the modified Manhattan algorithm slowed down the search, and they about tied on the medium difficulty case, but on the hard problem the modified algorithm gave a huge speed advantage. There is a similar trend with the number of nodes visited. Since the easy and medium difficulties are computed so quickly anyways, the modification overall was a definite advantage.
