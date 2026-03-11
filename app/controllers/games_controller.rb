class GamesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_game, only: %i[ edit update destroy ]

  def new
    @game = Game.new(lesson_id: params[:lesson_id])
  end

  def edit
  end

  def create
    @game = Game.new(game_params)

    if @game.save
      redirect_to lesson_path(@game.lesson, game_id: @game.id), notice: "Game was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @game.update(game_params)
      redirect_to lesson_path(@game.lesson, game_id: @game.id), notice: "Game was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    lesson = @game.lesson
    @game.destroy
    redirect_to lesson_path(lesson), notice: "Game was successfully destroyed."
  end

  private
    def set_game
      @game = Game.find(params[:id])
    end

    def game_params
      params.require(:game).permit(:lesson_id, :title, :game_type)
    end
end
