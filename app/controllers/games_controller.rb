class GamesController < ApplicationController
  before_action :set_game, only: [:show, :move]

  def create
    @game = Game.new(turn: "X", last_move: nil, winner: "")

    if @game.save
      @game.create_associated_subgames
      render json: @game.format_game_response

    else
      render json: @game.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: @game.format_game_response
  end

  def move
    begin
      if !params[:id] || !params[:subgame] || !params[:cell]
        raise Exception.new("Invalid Params")
      end
      @game.move(params[:subgame].to_i, params[:cell].to_i)
      render json: @game.format_game_response
    rescue Exception => exception
      render json: {Error: exception.message}.to_json
    end
  end

  private

  def set_game
    begin
      @game = Game.find(params[:id])
    rescue Exception => exception
      render json: {Error: "Invalid id"}.to_json
      return
    end
  end

end
