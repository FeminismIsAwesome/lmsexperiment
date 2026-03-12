require "application_system_test_case"

class CategorizeGameTest < ApplicationSystemTestCase
  setup do
    @instructor = users(:one)
    @lesson = lessons(:one)
    @game = @lesson.games.create!(
      title: "Fruit or Veggie",
      game_type: "categorize",
      options: {
        "categories" => [
          { "name" => "Fruits", "id" => "fruits" },
          { "name" => "Veggies", "id" => "veggies" }
        ],
        "items" => [
          { "name" => "Apple", "category" => "fruits" },
          { "name" => "Carrot", "category" => "veggies" }
        ],
        "time_limit" => 30,
        "points_per_item" => "1"
      }
    )
    login_as(@instructor)
  end

  test "playing the categorize game with mixed results" do
    visit lesson_path(@lesson, game_id: @game.id)

    assert_text "Score: 0"
    
    # Wait for the game controller to connect and show the start button
    assert_selector "[data-categorize-target='startButton']", text: "Start Game", wait: 5
    
    # First item in the list is "Apple", but we need to click Start Game *after* overriding shuffle
    # but the controller connects and might have already shuffled if it connected before our script.
    # So we call setupGame again after overriding shuffle to be sure.
    page.execute_script("const ctrl = Stimulus.getControllerForElementAndIdentifier(document.querySelector('[data-controller=\"categorize\"]'), 'categorize'); ctrl.shuffle = (arr) => arr; ctrl.setupGame();")

    click_on "Start Game"

    # In CategorizeGame, categories are not links/buttons but div cards with data-action
    # So click_on might not find them if they don't have a role="button" or similar.
    # Let's use find and click.
    
    # First item is "Apple" which is "fruits"
    # We should ensure "Apple" is shown
    assert_text "Apple"
    
    # Click "Fruits" (Correct)
    find(".category-card", text: "Fruits").click
    
    # Wait for transition
    sleep 0.7
    
    # Second item is "Carrot" which is "veggies"
    assert_text "Carrot"
    
    # Click "Fruits" (Incorrect)
    find(".category-card", text: "Fruits").click

    # Wait for completion
    sleep 0.7

    # Verify final score
    assert_text "Great job! You categorized everything. Final Score: 1"
    refute_text "Final Score: 01"
    refute_text "Final Score: 10"
  end
end
