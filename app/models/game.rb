class Game < ApplicationRecord
  has_many :subgames

  def move(subgame_index, cell)
    if valid_subgames.include?(subgame_index)
      @current_subgame = subgames.where(index: subgame_index).first

      @current_subgame.mark(turn, cell)

      if unfinished_subgames.length == 0
        calculate_winner
      end
    else
      raise Exception.new("Invalid Subgame")
    end
  end

  def add_error(message)
    self.errors.add(:messages, message)
  end

  def change_turn
    if turn == "O"
      self.turn = "X"
    else
      self.turn = "O"
    end

    save
  end

  def create_associated_subgames
    (0..8).each do |index|
      subgame = subgames.create(index: index, board: " , , , , , , , , ", winner: "")
    end
  end

  def valid_subgames
    return unfinished_subgames.include?(last_move) ? [last_move] : unfinished_subgames.sort
  end

  def calculate_winner
    x = 0
    o = 0
    subgames.each do |subgame|
      if subgame.winner == "X"
        x += 1
      elsif subgame.winner == "O"
        o += 1
      end
    end

    if x > o
      self.winner = "X"
    elsif o > x
      self.winner = "O"
    else
      self.winner = "Nobody"
    end

    save
  end

  def unfinished_subgames
    return subgames.where(winner: "").map { |s| s.index }
  end

  def format_game_response
    board_array = []

    subgames.each do |subgame|
      subgame_board = subgame.board.split(",")
      board_array[subgame.index] = subgame_board
    end

    return {:id => id, :board => board_array, :winner => winner, :turn => turn, :valid_subgames => valid_subgames}

  end

end
