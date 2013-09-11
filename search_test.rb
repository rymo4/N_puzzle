require_relative '15_puzzle'
require_relative 'greedy_search'
require_relative 'uniform_search'
require_relative 'idfs'
require_relative 'bfs_dfs'
require_relative 'a_star'

easy   = "( (1 2 3 0) (4 5 6 7) (8 9 10 11) (12 13 14 15) (0 3) )"
medium = "( (1 2 6 3) (4 5 10 7) (0 9 14 11) (8 12 13 15) (2 0) )"
hard   = "( (1 2 3 7) (4 5 6 15) (8 9 11 0) (12 13 14 10) (2 3) )"

goal_1   = ARGV[1] # or set this to a string with your own goal
goal_val = PuzzleNode.parse_state(goal_1, true)

start_string = ARGV[0] #or set this to one of the difficulties defined above

doing_hard_example = false

s0                   = PuzzleNode.parse_state(start_string)
s0.goal_value        = goal_val
goal_node            = PuzzleNode.parse_state(goal_1)
goal_node.goal_value = goal_val

unless doing_hard_example
  puts '---------- BREADTH FIRST SEARCH --------------'
  searcher = GeneralizedSearcher.new(s0, goal_node, :generate_states)
  start = Time.now
  solution = searcher.bfs
  puts "| Solution: #{solution}"
  puts "| Number of nodes visted: #{searcher.num_nodes_visited}"
  puts "| Size of open list: #{searcher.open.size}"
  puts "| Size of closed list: #{searcher.closed.size}"
  puts "| Number of nodes that were already generated: #{searcher.already_generated}"
  puts "| Time taken: #{Time.now - start}s"
end

puts '---------- DEPTH LIMITED SEARCH (DEPTH = 3) --------------'
searcher = DepthLimitedSearcher.new(s0, goal_node, :generate_states, 3)
start = Time.now
solution = searcher.dls
puts "| Solution: #{solution}"
puts "| Number of nodes visted: #{searcher.num_nodes_visited}"
puts "| Size of open list: #{searcher.open.size}"
puts "| Number of nodes that were already generated: #{searcher.already_generated}"
puts "| Time taken: #{Time.now - start}s"

puts '---------- DEPTH LIMITED SEARCH (DEPTH = 10) --------------'
searcher = DepthLimitedSearcher.new(s0, goal_node, :generate_states, 10)
start = Time.now
solution = searcher.dls
puts "| Solution: #{solution}"
puts "| Number of nodes visted: #{searcher.num_nodes_visited}"
puts "| Size of open list: #{searcher.open.size}"
puts "| Number of nodes that were already generated: #{searcher.already_generated}"
puts "| Time taken: #{Time.now - start}s"
unless doing_hard_example
  puts '------- ITERATIVE DEEPENING DEPTH LIMITED SEARCH (Start Depth = 4, Inc = 1) --------'
  searcher = DepthLimitedSearcher.new(s0, goal_node, :generate_states, 4, 1)
  start = Time.now
  solution = searcher.search
  puts "| Solution: #{solution}"
  puts "| Number of nodes visted: #{searcher.num_nodes_visited}"
  puts "| Size of open list: #{searcher.open.size}"
  puts "| Number of nodes that were already generated: #{searcher.already_generated}"
  puts "| Time taken: #{Time.now - start}s"

  puts '------------- UNIFORM COST SEARCH  -------------'
  searcher = UniformSearcher.new(s0, goal_node, :generate_states)
  start = Time.now
  solution = searcher.search
  puts "| Solution: #{solution}"
  puts "| Size of open list: #{searcher.open.size}"
  puts "| Size of closed list: #{searcher.closed.size}"
  puts "| Number of nodes visted: #{searcher.num_nodes_visited}"
  puts "| Number of nodes that were already generated: #{searcher.already_generated}"
  puts "| Time taken: #{Time.now - start}s"
end

puts '------------- GREEDY SEARCH (Manhattan) -------------'
searcher = GreedySearcher.new(s0, goal_node, :generate_states)
s0.heuristic = :manhattan
start = Time.now
solution = searcher.search
puts "| Solution: #{solution}"
puts "| Size of open list: #{searcher.open.size}"
puts "| Size of closed list: #{searcher.closed.size}"
puts "| Number of nodes visted: #{searcher.num_nodes_visited}"
puts "| Number of nodes that were already generated: #{searcher.already_generated}"
puts "| Time taken: #{Time.now - start}s"

puts '------------- GREEDY SEARCH (Modified Manhattan) -------------'
searcher = GreedySearcher.new(s0, goal_node, :generate_states)
s0.heuristic = :modified_manhattan
start = Time.now
solution = searcher.search
puts "| Solution: #{solution}"
puts "| Size of open list: #{searcher.open.size}"
puts "| Size of closed list: #{searcher.closed.size}"
puts "| Number of nodes visted: #{searcher.num_nodes_visited}"
puts "| Number of nodes that were already generated: #{searcher.already_generated}"
puts "| Time taken: #{Time.now - start}s"

puts '------------- A* SEARCH (Manhattan) -------------'
searcher = AStarSearcher.new(s0, goal_node, :generate_states)
s0.heuristic = :manhattan
start = Time.now
solution = searcher.search
puts "| Solution: #{solution}"
puts "| Size of open list: #{searcher.open.size}"
puts "| Size of closed list: #{searcher.closed.size}"
puts "| Number of nodes visted: #{searcher.num_nodes_visited}"
puts "| Number of nodes that were already generated: #{searcher.already_generated}"
puts "| Time taken: #{Time.now - start}s"

puts '------------- A* SEARCH (Modified Manhattan) -------------'
s0.heuristic = :modified_manhattan
searcher = AStarSearcher.new(s0, goal_node, :generate_states)
start = Time.now
solution = searcher.search
puts "| Solution: #{solution}"
puts "| Size of open list: #{searcher.open.size}"
puts "| Size of closed list: #{searcher.closed.size}"
puts "| Number of nodes visted: #{searcher.num_nodes_visited}"
puts "| Number of nodes that were already generated: #{searcher.already_generated}"
puts "| Time taken: #{Time.now - start}s"
