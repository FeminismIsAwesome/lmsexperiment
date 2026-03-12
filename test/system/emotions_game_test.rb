require "application_system_test_case"

class EmotionsGameTest < ApplicationSystemTestCase
  setup do
    @instructor = users(:one)
    @lesson = Lesson.create!(title: "Emotions Lesson")
    @game = @lesson.games.create!(
      title: "Identify Emotions",
      game_type: "emotions",
      options: {
        "categories" => [
          { "name" => "Happy", "id" => "happy" },
          { "name" => "Sad", "id" => "sad" },
          { "name" => "Angry", "id" => "angry" },
          { "name" => "Surprised", "id" => "surprised" }
        ],
        "items" => [
          { "name" => "Winning a prize", "category" => "happy" },
          { "name" => "Losing a toy", "category" => "sad" },
          { "name" => "Unexpected party", "category" => "surprised" }
        ],
        "time_limit" => 45,
        "points_per_item" => 2
      }
    )
    login_as(@instructor)
  end

  test "playing the emotions game with 4 categories" do
    visit lesson_path(@lesson, game_id: @game.id)

    assert_text "Score: 0"
    
    # Wait for the game controller and override shuffle
    page.execute_script("const ctrl = Stimulus.getControllerForElementAndIdentifier(document.querySelector('[data-controller=\"categorize\"]'), 'categorize'); ctrl.shuffle = (arr) => arr; ctrl.setupGame();")

    # Check that all 4 categories are visible (after setupGame makes gameArea visible/available if we were to start it)
    # Actually setupGame hides gameArea but categories should be in the DOM.
    # The error said "However, it was found 1 time including non-visible text."
    # So they are there but hidden.
    
    click_on "Start Game"

    assert_text "Happy"
    assert_text "Sad"
    assert_text "Angry"
    assert_text "Surprised"

    # First item: Winning a prize (Happy)
    assert_text "Winning a prize"
    find(".category-card", text: "Happy").click
    sleep 0.7
    
    # Second item: Losing a toy (Sad)
    assert_text "Losing a toy"
    find(".category-card", text: "Sad").click
    sleep 0.7
    
    # Third item: Unexpected party (Surprised)
    assert_text "Unexpected party"
    find(".category-card", text: "Surprised").click
    sleep 0.7

    # Verify final score: 3 correct * 2 points = 6
    assert_text "Great job! You categorized everything. Final Score: 6"
  end
end
