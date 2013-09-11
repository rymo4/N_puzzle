require_relative 'priority_queue'

class AStarSearcher
  attr_reader :open, :closed, :num_nodes_visited, :already_generated
  def initialize(initial_state, goal_state, generate_states)
    @open = PriorityQueue.new
    @open.insert(0, initial_state)
    @closed          = []
    @goal_state      = goal_state
    @generate_states = generate_states
    @num_nodes_visited = 0
    @already_generated = 0
    @cost = 0
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
      on_open  = @open.include?(n)
      on_close = @closed.include?(n)
      if on_open or on_close
        @already_generated += 1
        if n.g_hat > parent.g_hat + 1
          n.g_hat = parent.g_hat + 1
          if on_close
            @open.insert(n.g_hat + n.h_hat, n)
            @close.delete(n)
          end
        end
      else
        n.g_hat = parent.g_hat + 1
        @open.insert(n.g_hat + n.h_hat, n)
      end
    end
  end
end
