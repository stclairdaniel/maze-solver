# How to place 8 queens on a chessboard so none may attack the other

def solve
  x_pos = (0..7).to_a
  y_pos = (0..7).to_a
  y_pos.permutation.each do |y_perm|
    possible = x_pos.zip(y_perm)
    return possible if diagonal_check(possible)
  end
end

def diagonal_check(pos_array)
  (0...pos_array.size).each do |i|
    (i + 1...pos_array.size).each do |j|
      return false if same_diagonal(pos_array[i], pos_array[j])
    end
  end
  true
end

def same_diagonal(pos1, pos2)
  (pos1[0] - pos2[0]).abs == (pos1[1] - pos2[1]).abs
end
