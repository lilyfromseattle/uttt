class Subgame < ApplicationRecord
  belongs_to :game

  def move_is_valid?(cell)
    if cell > 8 || cell < 0
      raise Exception.new("Invalid Cell")
      return false
    end

    if cell_occupied?(cell)
      raise Exception.new("Cell Occupied")
      return false
    end

    return true
  end

  def cell_occupied?(cell)
    return board.split(",")[cell] != " "
  end

  def mark(player, cell)
    if move_is_valid?(cell)
      board_array = board.split(",")

      board_array[cell] = player

      self.board = board_array.join(",")

      game.last_move = cell
      game.change_turn

      if win?
        self.winner = player
      elsif tie?
        self.winner = "-"
      end
      save
    end
  end

  def tie?
    return !board.include?(" ")
  end

  def win?
    winning_combos = [
      [0,1,2], [3,4,5], [6,7,8],
      [0,3,6], [1,4,7], [2,5,8],
      [0,4,8], [2,4,6]
    ]

    winner = false

    board_array = board.split(",")
    winning_combos.each do |combo|
      if board_array[combo[0]] == "X" && board_array[combo[1]] == "X" && board_array[combo[2]] == "X"
        winner = true
      elsif board_array[combo[0]] == "O" && board_array[combo[1]] == "O" && board_array[combo[2]] == "O"
        winner =  true
      end
    end

    return winner
  end
end
