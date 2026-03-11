require "test_helper"

class LessonsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @lesson = lessons(:one)
    @user = users(:one)
    sign_in @user
  end

  test "should get student index even if not signed in" do
    sign_out :user
    get student_index_lessons_url
    assert_response :success
    assert_select "h1", "Available Lessons"
  end

  test "should get student show even if not signed in" do
    sign_out :user
    get student_show_lesson_url(@lesson)
    assert_response :success
  end

  test "should redirect to login when accessing index and not signed in" do
    sign_out :user
    get lessons_url
    assert_redirected_to new_user_session_url
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
