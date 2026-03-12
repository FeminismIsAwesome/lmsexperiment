require "test_helper"

class AdvancedCategorizeGameTest < ActionDispatch::SystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    @lesson = Lesson.create!(title: "Custom Game Lesson")
    @user = users(:one)
    sign_in @user
  end

  test "creating a categorize game with custom items" do
    visit new_game_path(lesson_id: @lesson.id)

    fill_in "Title", with: "Custom Fruit Sort"
    select "Categorize", from: "Game type"

    # Fill in time limit
    fill_in "Time Limit (seconds)", with: "45"
    
    # Add a custom item
    click_button "Add Item"
    
    # We need to find the newly added fields. Since they use a timestamp, we target by the labels within the nested fields.
    within ".nested-fields[data-new-record='true']" do
      fill_in "Name", with: "Dragonfruit"
      fill_in "Category", with: "fruits"
      fill_in "Image URL", with: "https://example.com/dragonfruit.jpg"
    end

    click_on "Create Game"

    assert_text "Game was successfully created."
    
    game = Game.last
    options = game.categorize_options
    
    assert_equal 45, options["time_limit"]
    
    # Check if our custom item is there
    dragonfruit = options["items"].find { |i| i["name"] == "Dragonfruit" }
    assert dragonfruit.present?
    assert_equal "fruits", dragonfruit["category"]
    assert_equal "https://example.com/dragonfruit.jpg", dragonfruit["image"]
    
    # Since we added ONE item, it should NOT use defaults anymore
    assert_equal 1, options["items"].length
  end

  test "updating a categorize game by removing an item" do
    # Create a game with two items first
    game = @lesson.games.create!(
      title: "To be edited",
      game_type: "categorize",
      options: {
        items: [
          { name: "Item 1", category: "fruits", image: "" },
          { name: "Item 2", category: "veggies", image: "" }
        ]
      }
    )

    visit edit_game_path(game)

    # Find the first item and click remove
    first(".nested-fields").click_button "Remove"

    click_on "Update Game"

    assert_text "Game was successfully updated."
    
    game.reload
    options = game.categorize_options
    assert_equal 1, options["items"].length
    assert_equal "Item 2", options["items"].first["name"]
  end
end
