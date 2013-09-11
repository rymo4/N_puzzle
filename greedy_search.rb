require_relative 'priority_queue'

class GreedySearcher
  attr_reader :closed, :open, :already_generated, :num_nodes_visited
  def initialize(initial_state, goal_state, generate_states)
    @open = PriorityQueue.new
    @open.insert(0, initial_state)
    @closed = []
    @goal_state = goal_state
    @generate_states = generate_states
    @already_generated = 0
    @num_nodes_visited = 0
  end

  def search
    return nil if @open.empty?
    node = @open.min
    @closed << node
    goal = @goal_state.respond_to?(:value) ? @goal_state.value : @goal_state
    return node if node.value == goal
    add_states_from node
    search
  end

  def add_states_from parent
    nodes = parent.send(@generate_states)
    nodes.each do |n|
      @num_nodes_visited += 1
      n.g_hat = parent.g_hat + 1
      if (@open.include?(n) or @closed.include?(n))
        @already_generated += 1
      else
        @open.insert(n.h_hat, n)
      end
    end
  end
end
