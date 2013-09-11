class PuzzleNode
  attr_reader :value, :moves
  attr_accessor :g_hat, :heuristic, :goal_value

  def initialize(value, blank, goal_value, heuristic = :manhattan, moves = '')
    @goal_value = goal_value
    @heuristic = heuristic
    @moves = moves
    @value = value
    @blank = blank
    @g_hat = 1
  end

  def self.parse_state state, value_only = false
    # Yay for Ruby one liners
    ary = state.split(/[ \(\)]+/).reject{|e| e == ""}.map(&:to_i)
    squares = ary[0..-3].each_slice(4).to_a
    blank = ary[-2..-1]
    if value_only
      squares
    else
      new(squares, blank, nil, @heuristic)
    end
  end

  def generate_states
    states = [ ]
    states << west  if west?
    states << north if north?
    states << east  if east?
    states << south if south?
    states.shuffle
  end

  def h_hat
    # manhattan distance. Ya, this is ugly
    manhattan_sum = 0
    @value.each_with_index do |row_ary, row_i|
      row_ary.each_with_index do |col_el, col_i|
        row, col = find_position_in_goal(col_el)
        distance = (row_i - row).abs + (col_i - col).abs
        if @heuristic != :manhattan
          range_of_vals = @goal_value[row_i]#(row_i*4)..(row_i*4+3)
          i = -1
          if range_of_vals.include?(col_el) and
            range_of_vals.any? { |e|
              i += 1
              (e < col_el and col_i < i) or (e > col_el and col_i > i)
            }
              distance += 1
          end
        end
        manhattan_sum += distance
      end
    end
    manhattan_sum
  end

  def find_position_in_goal num
    goal = [[0, 1, 2, 3], [4, 5, 6, 7], [8, 9, 10, 11], [12, 13, 14, 15]]
    row = goal.index { |row| row.include?(num) }
    col = goal[row].index(num)
    return row, col
  end

  def move_blank_to to_row, to_col, move
    val  = Marshal.load(Marshal.dump(@value))
    row_1, col_1 = @blank
    blnk = [to_row, to_col]
    val[row_1][col_1] = value[to_row][to_col]
    val[to_row][to_col] = 0
    PuzzleNode.new(val, blnk, @goal_value, @heuristic, @moves + move)
  end

  def north?
    @blank[0] > 0 and @moves[-1] != 'S'
  end
  def north
    row, col = @blank
    move_blank_to(row - 1, col, 'N')
  end
  def south?
    @blank[0] < 3 and @moves[-1] != 'N'
  end
  def south
    row, col = @blank
    move_blank_to(row + 1, col, 'S')
  end
  def east?
    @blank[1] < 3 and @moves[-1] != 'W'
  end
  def east
    row, col = @blank
    move_blank_to(row, col + 1, 'E')
  end
  def west?
    @blank[1] > 0 and @moves[-1] != 'E'
  end
  def west
    row, col = @blank
    move_blank_to(row, col - 1, 'W')
  end
  def to_s
    @moves
  end
  def == other
    @value == other.value
  end
end
