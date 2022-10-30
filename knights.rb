require 'pry-byebug' # binding.pry

class Knight
  def initialize(position=[0,1])
    @position = position
    @board = build_board
  end

  def check_position(position = @position)
    return position.is_a?(Array) && position.size == 2 && position[0].between?(0,7) && position[1].between?(0,7)
  end

  def valid_moves(position = @position)
    all_moves = [[2,1], [2,-1], [-2,1], [-2,-1], [1,2], [1,-2], [-1,2], [-1,-2]]
    result = all_moves.map {|m| [position[0]+m[0], position[1]+m[1]]}.select {|r| check_position(r)}
  end

  def print_board(p_board = @board, moves = false)
    p_board = p_board.dup
    if moves == true
      valid_moves(@position).each {|x,y| p_board[x][y] = "@"}
    end
    #print board
    for x in (0..7)
        puts p_board[x].join(' ')
    end
  end

  def build_board
     board = []
     (0..7).each do
       board.push(['w','b','w','b','w','b','w','b'])
     end
     board[@position[0]][@position[1]] = "*"
     return board
  end

  def find_route(start, goal)
    return "error" if !check_position(start) || !check_position(goal)
    return "already there" if start == goal
    f_board = @board.dup

    #bfs search :-)
    to_visit = [[start,0,nil]]
    visited = []
    visited_pred = []
    while to_visit
      current = to_visit.shift
      if current[0] == goal
        visited.push(current[0])
        visited_pred.push(current[1])
        return trace_route(start, goal, visited, visited_pred)
      end
      valid_moves(current[0]).each do |v|
        if !visited.include?(v)
          to_visit.push([v, current[0]]) 
        end
      end
      visited.push(current[0])
      visited_pred.push(current[1])
      f_board[current[0][0]][current[0][1]] = "X"
    end
  end

  def trace_route(start, goal, visited, visited_pred)
    trace = [goal]
    current = goal
    while true
      idx = visited.find_index(current)
      current = visited_pred[idx]
      trace.push(current)
      if current == start
        p "You made it in #{trace.size-1} moves! Here's your path"
        return trace.reverse
      end
    end
  end
end

caballo = Knight.new()

#p caballo.check_position
#p caballo.valid_moves
#caballo.print_board
p caballo.find_route([3,3], [4,3])
p caballo.find_route([0,0], [3,3])
p caballo.find_route([3,3], [0,0])