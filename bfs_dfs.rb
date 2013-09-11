require_relative 'priority_queue'

class GeneralizedSearcher
  attr_reader :open, :closed, :num_nodes_visited, :already_generated
  def initialize(initial_state, goal_state, generate_states)
    @open   = [initial_state]
    @closed = []
    @goal_state = goal_state
    @generate_states = generate_states
    @already_generated = 0
    @num_nodes_visited = 0
  end

  def search
    return nil if @open.empty?
    node = @open.shift
    @num_nodes_visited += 1
    @closed << node
    goal = @goal_state.respond_to?(:value) ? @goal_state.value : @goal_state
    return node if node.value == goal
    add_states_from node
    search
  end

  def add_states_from node
    nodes = node.send(@generate_states)
    union = @open + @closed
    case @type
    when :bfs
      nodes.each { |n| union.include?(n) ? @already_generated += 1 : @open << n }
    when :dfs
      nodes.each { |n| @open.unshift(n) unless union.include?(n) }
    end
  end

  def method_missing(name, *args, &block)
    if [:dfs, :bfs].include? name
      @type = name
      search
    else
      super
    end
  end
end
