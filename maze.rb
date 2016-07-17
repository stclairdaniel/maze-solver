class MazeSolver
  COORDS = [[-1, 0], [1, 0], [0, -1], [0, 1]].freeze

  def initialize(filename)

    @maze_array = []

    File.open(filename).each_line do |line|
      @maze_array << line.chomp.split('')
    end

    @num_rows = @maze_array.size
    @num_cols = @maze_array[0].size

    @flattened_maze = @maze_array.flatten
    @start_row = @flattened_maze.index('S') / @num_cols
    @start_col = @flattened_maze.index('S') % @num_cols

    @end_row = @flattened_maze.index('E') / @num_cols
    @end_col = @flattened_maze.index('E') % @num_cols

    #initialize start as 0 for bfs
    @maze_array[@start_row][@start_col] = 0

  end

  def render
    @maze_array.each do |row|
      line = []
      row.each do |el|
        unless el.is_a?(Integer)
          line << " #{el} "
        else
          line << "   "
        end
      end
      puts line.join("")
    end
  end

  def neighbors(row, col)
    neighbors = COORDS.map { |x, y| [row + x, col + y] }
  end

  def valid_neighbors(row, col)
    neighbors(row,col).select do |x, y|
      x.between?(0, @num_rows) &&
        y.between?(0, @num_cols) &&
        @maze_array[x][y] == ' '
    end
  end

  def bfs
    queue = [[@start_row, @start_col]]
    until queue.empty?
      current_pos = queue.shift
      return if @maze_array[current_pos[0]][current_pos[1]] == 'E'
      valid_neighbors(current_pos[0], current_pos[1]).each do |pos|
        @maze_array[pos[0]][pos[1]] = @maze_array[current_pos[0]][current_pos[1]] + 1
        queue << pos
      end
    end
    @maze_array
  end

  def trace_path
    path = []
    current_pos = [@end_row, @end_col]
    until path.include?([@start_row, @start_col])
      neighbors = neighbors(current_pos[0], current_pos[1]).select do |neighbor|
        @maze_array[neighbor[0]][neighbor[1]].is_a?(Integer)
      end
      lowest_neighbor = neighbors.sort_by { |x, y| @maze_array[x][y]}[0]
      path << lowest_neighbor
      current_pos = path[-1]
    end
    path.reverse
  end

  def draw_path
    trace_path.each do |pos|
      @maze_array[pos[0]][pos[1]] = '#'
    end
  end

end

if __FILE__ == $PROGRAM_NAME
  maze = MazeSolver.new('maze.txt')
  maze.bfs
  maze.draw_path
  maze.render
end
