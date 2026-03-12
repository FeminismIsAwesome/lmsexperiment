require "test_helper"

class LessonsUpdatePositionsTest < ActionDispatch::IntegrationTest
  setup do
    @instructor = users(:one)
    @lesson = lessons(:one)
    @page1 = pages(:one)
    @page2 = pages(:two)
    
    @page1.update!(position: 1)
    @page2.update!(position: 2)
    
    sign_in(@instructor)
  end

  test "should update positions via PATCH update_positions" do
    patch update_positions_lesson_path(@lesson), params: {
      positions: [
        { id: @page1.id, type: "Page", position: 2 },
        { id: @page2.id, type: "Page", position: 1 }
      ]
    }, as: :json

    assert_response :success
    assert_equal 2, @page1.reload.position
    assert_equal 1, @page2.reload.position
  end
end
