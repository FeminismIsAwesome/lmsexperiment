require "test_helper"

class UnifiedSidebarTest < ActionDispatch::IntegrationTest
  setup do
    @lesson = Lesson.create!(title: "Unified Sidebar Lesson")
    @page1 = @lesson.pages.create!(title: "Page One", content: "Content One", position: 1)
    @game1 = @lesson.games.create!(title: "Game One", game_type: "memory_match", position: 2)
    @page2 = @lesson.pages.create!(title: "Page Two", content: "Content Two", position: 3)
  end

  test "sidebar displays pages and games in the correct order" do
    get student_show_lesson_path(@lesson)
    assert_response :success

    assert_select "aside.sidebar" do
      # We look for nav-item within the first nav-group to exclude the "Back to all lessons" link
      assert_select ".nav-group", 1 do 
        assert_select ".nav-item" do |items|
          assert_equal 3, items.size
          assert_match "Page One", items[0].text
          assert_match "🎮 Game One", items[1].text
          assert_match "Page Two", items[2].text
        end
      end
    end
  end

  test "navigation works for both pages and games from the unified sidebar" do
    # Go to Page One
    get student_show_lesson_path(@lesson, page_id: @page1.id)
    assert_response :success
    assert_select "h1", "Page One"
    assert_select ".nav-item.active", text: "Page One"

    # Go to Game One
    get student_show_lesson_path(@lesson, game_id: @game1.id)
    assert_response :success
    assert_select "h1", "Game One"
    assert_select ".nav-item.active", text: "🎮 Game One"

    # Go to Page Two
    get student_show_lesson_path(@lesson, page_id: @page2.id)
    assert_response :success
    assert_select "h1", "Page Two"
    assert_select ".nav-item.active", text: "Page Two"
  end
end
