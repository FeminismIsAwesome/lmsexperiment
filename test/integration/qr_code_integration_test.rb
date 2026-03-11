require "test_helper"

class QrCodeIntegrationTest < ActionDispatch::IntegrationTest
  test "instructor sees QR codes on lessons index and show" do
    lesson = lessons(:one)
    get lessons_path
    assert_response :success
    assert_select "h3", "Student Access QR Code"
    # One for global access, plus one for each lesson (fixture has one lesson 'one' by default usually)
    # Actually fixtures might have more. Let's check how many SVGs are there.
    # At least 2: one for student_index, one for lesson 'one'
    assert_select "svg", minimum: 2
    assert_select "code", student_index_lessons_url
    assert_select "code", student_show_lesson_url(lesson)

    get lesson_path(lesson)
    assert_response :success
    assert_select "h4", "Student QR Code"
    assert_select "svg"
    assert_select "code", student_show_lesson_url(lesson)
  end

  test "student does not see QR codes" do
    lesson = lessons(:one)
    get student_index_lessons_path
    assert_response :success
    assert_select "h3", text: "Student Access QR Code", count: 0
    assert_select "svg", count: 0

    get student_show_lesson_path(lesson)
    assert_response :success
    assert_select "h4", text: "Student QR Code", count: 0
    assert_select "svg", count: 0
  end
end
