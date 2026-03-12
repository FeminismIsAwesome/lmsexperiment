require "test_helper"

class GameCustomizationTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @lesson = lessons(:one)
    sign_in @user
  end

  test "can create a game with custom words" do
    assert_difference("Game.count") do
      post games_path, params: { 
        game: { 
          lesson_id: @lesson.id, 
          title: "Custom Memory Game", 
          game_type: "memory_match",
          position: 1,
          options: { words: "One, Two, Three" }
        } 
      }
    end

    game = Game.last
    assert_equal ["One", "Two", "Three"], game.memory_match_words
    
    get lesson_path(@lesson, game_id: game.id)
    assert_response :success
    # Use a simpler match that avoids encoding issues if possible, or matches the encoded version correctly
    assert_match 'data-memory-match-words-value=', response.body
    assert_match 'One', response.body
    assert_match 'Two', response.body
    assert_match 'Three', response.body
  end

  test "uses default words when none are provided" do
    post games_path, params: { 
      game: { 
        lesson_id: @lesson.id, 
        title: "Default Memory Game", 
        game_type: "memory_match",
        position: 1
      } 
    }

    game = Game.last
    assert_equal Game::DEFAULT_WORDS, game.memory_match_words
    
    get lesson_path(@lesson, game_id: game.id)
    assert_response :success
    assert_match 'data-memory-match-words-value=', response.body
    assert_match 'Honest', response.body
    assert_match 'respect', response.body
  end

  test "can update a game with new custom words" do
    game = Game.create!(lesson: @lesson, title: "Initial Game", game_type: "memory_match", position: 1)
    
    patch game_path(game), params: { 
      game: { 
        options: { words: "Alpha, Beta" }
      } 
    }
    
    game.reload
    assert_equal ["Alpha", "Beta"], game.memory_match_words
    
    get lesson_path(@lesson, game_id: game.id)
    assert_response :success
    assert_match 'data-memory-match-words-value=', response.body
    assert_match 'Alpha', response.body
    assert_match 'Beta', response.body
  end
end
