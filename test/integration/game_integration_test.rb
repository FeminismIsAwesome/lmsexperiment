require "test_helper"

class GameIntegrationTest < ActionDispatch::IntegrationTest
  setup do
    @lesson = Lesson.create!(title: "Game Lesson")
  end

  test "can create a memory match game for a lesson" do
    assert_difference "Game.count", 1 do
      post games_path, params: {
        game: {
          lesson_id: @lesson.id,
          title: "Social Wellbeing - The Principle of Relationship Game",
          game_type: "memory_match"
        }
      }
    end

    assert_redirected_to lesson_path(@lesson, game_id: Game.last.id)
    follow_redirect!
    
    assert_select "h2", "Social Wellbeing - The Principle of Relationship Game"
    assert_select "[data-controller='memory-match']"
    
    # Check if words are correctly passed to the controller
    # The view has spaces in the JSON array, but to_json doesn't.
    expected_attr = '["Honest", "trust", "equality", "boundaries", "communication", "respect"]'
    assert_select "[data-memory-match-words-value='#{expected_attr}']"
  end

  test "student can view and interact with the game" do
    game = @lesson.games.create!(title: "Test Game", game_type: "memory_match")
    
    get student_show_lesson_path(@lesson, game_id: game.id)
    assert_response :success
    
    assert_select "h2", "Test Game"
    assert_select "a", text: "Edit this game", count: 0
    assert_select "a", text: "Add a new game", count: 0
    
    # Check for the sidebar link
    assert_select "div.sidebar" do
      assert_select "a", text: "Test Game"
    end
  end
end
