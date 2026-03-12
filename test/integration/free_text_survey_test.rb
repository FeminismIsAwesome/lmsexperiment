require "test_helper"

class FreeTextSurveyIntegrationTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @lesson = lessons(:one)
    @page = pages(:one)
    sign_in @user
  end

  test "can create a page with a free text question" do
    assert_difference "Question.count", 1 do
      post pages_path, params: {
        page: {
          lesson_id: @lesson.id,
          title: "Free Text Page",
          content: "Content",
          position: 10,
          questions_attributes: {
            "0" => {
              text: "What do you think?",
              question_type: "free_text"
            }
          }
        }
      }
    end

    new_page = Page.last
    question = new_page.questions.first
    assert_equal "free_text", question.question_type
    assert_equal "What do you think?", question.text
  end

  test "student can submit a free text response" do
    # Create a free text question
    question = @page.questions.create!(text: "Your feedback?", question_type: "free_text")
    
    # Sign out to be treated as a student
    sign_out @user
    
    get student_show_lesson_path(@lesson, page_id: @page.id)
    assert_response :success
    assert_select "textarea[name=answer_text]"

    assert_difference "QuestionResponse.count", 1 do
      post question_responses_path, params: {
        question_id: question.id,
        answer_text: "This is my feedback."
      }, headers: { "HTTP_REFERER" => student_show_lesson_url(@lesson, page_id: @page.id) }
    end

    assert_redirected_to student_show_lesson_url(@lesson, page_id: @page.id)
    follow_redirect!
    
    assert_match "This is my feedback.", response.body
    assert_match "Your answer:", response.body
  end

  test "instructor can see all free text responses" do
    question = @page.questions.create!(text: "Your feedback?", question_type: "free_text")
    question.question_responses.create!(session_hash: "hash1", answer_text: "Feedback 1")
    question.question_responses.create!(session_hash: "hash2", answer_text: "Feedback 2")

    get lesson_path(@lesson, page_id: @page.id)
    assert_response :success
    
    assert_match "Feedback 1", response.body
    assert_match "Feedback 2", response.body
    assert_match "Total responses: <strong>2</strong>", response.body
  end
end
