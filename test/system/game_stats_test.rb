require "test_helper"

class GameStatsTest < ActionDispatch::SystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    @lesson = Lesson.create!(title: "Stats Lesson")
    @game = @lesson.games.create!(
      title: "Categorize Game",
      game_type: "categorize",
      options: {
        time_limit: 30,
        points_per_item: 1,
        categories: [
          { name: "A", id: "a" },
          { name: "B", id: "b" }
        ],
        items: [
          { name: "Item 1", category: "a" },
          { name: "Item 2", category: "a" }
        ]
      }
    )
    @user = users(:one)
  end

  test "tracking visits, starts, and completions for categorize game" do
    # 1. Visit as student (should record visit)
    visit student_show_lesson_path(@lesson, game_id: @game.id)
    assert_text "Categorize Game"
    
    # Verify visit event in DB
    assert_equal 1, @game.events.where(event_type: "visit").count
    
    # 2. Start game
    click_button "Start Game"
    assert_text "Time: 30s"
    
    # Verify start event in DB
    assert_equal 1, @game.events.where(event_type: "start").count
    
    # 3. Complete game
    # Click category A for Item 1
    find(".category-card[data-category-id='a']").click
    sleep 0.6 # Wait for transition
    
    # Click category A for Item 2
    find(".category-card[data-category-id='a']").click
    sleep 0.6 # Wait for transition
    
    assert_text "Great job! You categorized everything."
    
    # Verify engaged and completed events in DB
    assert_equal 1, @game.events.where(event_type: "engaged").count
    assert_equal 1, @game.events.where(event_type: "completed").count
    
    # 4. Check stats as instructor
    sign_in @user
    visit lesson_path(@lesson, game_id: @game.id)
    
    within ".stats-badge" do
      assert_text "Visits: 1"
      assert_text "Starts: 1"
      assert_text "Engaged: 1"
      assert_text "Completed: 1"
    end
    
    # Check the card analytics too
    assert_text "1\nVISITS"
    assert_text "1\nSTARTS"
    assert_text "1\nCOMPLETIONS"
  end
end
