require "test_helper"

class GameEventsTest < ActionDispatch::IntegrationTest
  setup do
    @lesson = Lesson.create!(title: "Event Lesson")
    @game = Game.create!(lesson: @lesson, title: "Memory Match", game_type: "memory_match")
  end

  test "can record game events" do
    assert_difference "Event.count", 3 do
      post events_path, params: { event: { game_id: @game.id, event_type: "start" } }
      assert_response :created

      post events_path, params: { event: { game_id: @game.id, event_type: "engaged" } }
      assert_response :created

      post events_path, params: { event: { game_id: @game.id, event_type: "completed" } }
      assert_response :created
    end
  end

  test "aggregate data is visible to instructors but not students" do
    sign_in users(:one)
    # Record some events
    Event.create!(game: @game, event_type: "start", session_hash: "visitor1")
    Event.create!(game: @game, event_type: "start", session_hash: "visitor2")
    Event.create!(game: @game, event_type: "completed", session_hash: "visitor1")

    # Instructor view
    get lesson_path(@lesson, game_id: @game.id)
    assert_response :success
    assert_select "h3", "Instructor View: Game Interactions (Aggregate)"
    assert_select "li", /Unique students who started: 2/
    assert_select "li", /Unique students who completed: 1/

    # Student view
    get student_show_lesson_path(@lesson, game_id: @game.id)
    assert_response :success
    assert_select "h3", text: "Instructor View: Game Interactions (Aggregate)", count: 0
  end
end
