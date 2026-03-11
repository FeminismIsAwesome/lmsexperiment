require "test_helper"

class GamesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @lesson = Lesson.create!(title: "Test Lesson")
    @game = @lesson.games.create!(title: "Initial Game", game_type: "memory_match")
    sign_in users(:one)
  end

  test "should get new" do
    get new_game_url(lesson_id: @lesson.id)
    assert_response :success
  end

  test "should create game" do
    assert_difference("Game.count") do
      post games_url, params: { game: { game_type: "memory_match", lesson_id: @lesson.id, title: "New Game" } }
    end

    assert_redirected_to lesson_url(@lesson, game_id: Game.last.id)
  end

  test "should get edit" do
    get edit_game_url(@game)
    assert_response :success
  end

  test "should update game" do
    patch game_url(@game), params: { game: { title: "Updated Game" } }
    assert_redirected_to lesson_url(@lesson, game_id: @game.id)
  end

  test "should destroy game" do
    assert_difference("Game.count", -1) do
      delete game_url(@game)
    end

    assert_redirected_to lesson_url(@lesson)
  end
end
