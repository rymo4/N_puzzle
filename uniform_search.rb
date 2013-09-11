class UniformSearcher
  attr_reader :open, :closed, :num_nodes_visited, :already_generated
  def initialize(initial_state, goal_state, generate_states)
    @open = PriorityQueue.new
    @open.insert(0, initial_state)
    @already_generated = 0
    @closed = []
    @goal_state = goal_state
    @generate_states = generate_states
    @cost = 0
    @num_nodes_visited = 0
  end

  def search
    return nil if @open.empty?
    node = @open.min
    @num_nodes_visited += 1
    @closed << node
    goal = @goal_state.respond_to?(:value) ? @goal_state.value : @goal_state
    return node if node.value == goal
    add_states_from node
    search
  end

  def add_states_from parent
    nodes = parent.send(@generate_states)
    nodes.each do |n|
      n.g_hat += parent.g_hat
      (@open.include?(n) or @closed.include?(n)) ? @already_generated += 1 : @open.insert(n.g_hat, n)
    end
  end
end
