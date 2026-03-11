require "test_helper"

class LessonsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @lesson = lessons(:one)
  end

  test "should get student index" do
    get student_index_lessons_url
    assert_response :success
    assert_select "h1", "Available Lessons"
    assert_select "a", text: "New lesson", count: 0
  end

  test "should get student show" do
    get student_show_lesson_url(@lesson)
    assert_response :success
    assert_select "a", text: "Edit this lesson", count: 0
    assert_select "button", text: "Destroy this lesson", count: 0
    assert_select "a", text: "Add a new page", count: 0
    assert_select "a", text: "Back to lessons", count: 1
    assert_select "a[href=?]", student_index_lessons_path
  end

  test "should get index" do
    get lessons_url
    assert_response :success
  end

  test "should get new" do
    get new_lesson_url
    assert_response :success
  end

  test "should create lesson" do
    assert_difference("Lesson.count") do
      post lessons_url, params: { lesson: { title: @lesson.title } }
    end

    assert_redirected_to lesson_url(Lesson.last)
  end

  test "should show lesson" do
    get lesson_url(@lesson)
    assert_response :success
  end

  test "should get edit" do
    get edit_lesson_url(@lesson)
    assert_response :success
  end

  test "should update lesson" do
    patch lesson_url(@lesson), params: { lesson: { title: @lesson.title } }
    assert_redirected_to lesson_url(@lesson)
  end

  test "should destroy lesson" do
    assert_difference("Lesson.count", -1) do
      delete lesson_url(@lesson)
    end

    assert_redirected_to lessons_url
  end
end
