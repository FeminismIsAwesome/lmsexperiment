require "test_helper"

class SurveyAggregationTest < ActionDispatch::IntegrationTest
  setup do
    @lesson = Lesson.create!(title: "Aggregation Lesson")
    @page = Page.create!(lesson: @lesson, title: "Survey Page", content: "Aggregation Test", position: 1)
    @question = @page.questions.create!(text: "Favorite fruit?", multiple_answers: true)
    @apple = @question.question_options.create!(text: "Apple")
    @banana = @question.question_options.create!(text: "Banana")
    
    # Create responses for different sessions
    QuestionResponse.create!(question: @question, question_option: @apple, session_hash: "visitor1")
    QuestionResponse.create!(question: @question, question_option: @banana, session_hash: "visitor1")
    QuestionResponse.create!(question: @question, question_option: @apple, session_hash: "visitor2")
  end

  test "instructor view shows aggregated data even if they haven't voted" do
    sign_in users(:one)
    # Instructor view (regular show)
    get lesson_path(@lesson, page_id: @page.id)
    assert_response :success
    
    assert_select "p", text: /Total respondents: 2/
    assert_select "li", text: /Apple:.*2.*votes.*\(100.0%\)/
    assert_select "li", text: /Banana:.*1.*votes.*\(50.0%\)/
  end

  test "student view does not show aggregated data if they haven't voted" do
    # Student view
    get student_show_lesson_path(@lesson, page_id: @page.id)
    assert_response :success
    
    # Should see the form, not the results
    assert_select "form[action='/question_responses']", count: 1
    assert_select "p", text: /Total respondents:/, count: 0
  end

  test "student view shows aggregated data after voting" do
    # First visit student view
    get student_show_lesson_path(@lesson, page_id: @page.id)
    
    # Vote as student (implicitly creates a session_hash)
    post question_responses_path, params: { 
      question_id: @question.id, 
      question_option_ids: [@banana.id] 
    }, headers: { "HTTP_REFERER" => student_show_lesson_path(@lesson, page_id: @page.id) }
    
    assert_redirected_to student_show_lesson_url(@lesson, page_id: @page.id)
    follow_redirect!
    assert_select "p", text: /Total respondents: 3/ # visitor1, visitor2, and current student
    assert_select "li", text: /Banana:.*2.*votes.*\(66.7%\).*<- Your choice/
    assert_select "li", text: /Apple:.*2.*votes.*\(66.7%\)/
  end
end
