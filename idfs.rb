require 'set'

class DepthLimitedSearcher
  attr_reader :num_nodes_visited, :open, :already_generated
  def initialize(initial_state, goal_state, generate_states, depth, increment = 1)
    @depth             = depth
    @increment         = increment
    @goal_state        = goal_state
    @generate_states   = generate_states
    @current           = initial_state
    @num_nodes_visited = 0
    @open = Set.new
    @already_generated = 0
  end

  def search
    found_goal = dls
    return found_goal if found_goal
    @depth += @increment
    search
  end

  def dls(node = @current, depth = @depth)
    if depth >= 0
      goal = @goal_state.respond_to?(:value) ? @goal_state.value : @goal_state
      return node if node.value == goal
      children = node.send(@generate_states)
      @num_nodes_visited += children.size
      return children.map { |c|
        if @open.include? c.value
          @already_generated += 1
        else
          @open << c.value
        end
        dls(c, depth - 1)
      }.reject(&:nil?)[0]
    end
  end
end
