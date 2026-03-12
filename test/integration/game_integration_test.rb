require "test_helper"

class GameIntegrationTest < ActionDispatch::IntegrationTest
  setup do
    @lesson = Lesson.create!(title: "Game Lesson")
    @user = users(:one)
    sign_in @user
  end

  test "can create a memory match game for a lesson" do
    assert_difference "Game.count", 1 do
      post games_path, params: {
        game: {
          lesson_id: @lesson.id,
          title: "Social Wellbeing - The Principle of Relationship Game",
          game_type: "memory_match",
          position: 1
        }
      }
    end

    assert_redirected_to lesson_path(@lesson, game_id: Game.last.id)
    follow_redirect!
    
    assert_select "h1", "Social Wellbeing - The Principle of Relationship Game"
    assert_select "[data-controller='memory-match']"
    
    # Check if words are correctly passed to the controller
    # The view has HTML-encoded JSON array.
    assert_select "[data-memory-match-words-value]" do |element|
      value = element.first["data-memory-match-words-value"]
      assert_match "Honest", value
      assert_match "respect", value
    end
  end

  test "student can view and interact with the game even if not signed in" do
    sign_out @user
    game = @lesson.games.create!(title: "Test Game", game_type: "memory_match", position: 1)
    
    get student_show_lesson_path(@lesson, game_id: game.id)
    assert_response :success
    
    assert_select "h1", "Test Game"
    assert_select "a", text: "Edit this game", count: 0
    assert_select "a", text: "Add a new game", count: 0
    
    # Check for the sidebar link
    assert_select "aside.sidebar" do
      assert_select "a", text: "🎮 Test Game"
    end
  end
end
