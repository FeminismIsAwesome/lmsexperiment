require "test_helper"

class EventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @game = games(:one)
  end

  test "should create event" do
    assert_difference("Event.count") do
      post events_url, params: { event: { game_id: @game.id, event_type: "start" } }
    end
    assert_response :created
  end
end
