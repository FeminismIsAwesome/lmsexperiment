require "test_helper"

class SurveyIntegrationTest < ActionDispatch::IntegrationTest
  setup do
    @lesson = Lesson.create!(title: "Survey Lesson")
    @page = Page.create!(lesson: @lesson, title: "Survey Page", content: "Check out this survey", position: 1)
    @single_choice_question = @page.questions.create!(text: "Favorite color?", multiple_answers: false)
    @single_choice_question.question_options.create!(text: "Red")
    @single_choice_question.question_options.create!(text: "Blue")
    
    @multi_choice_question = @page.questions.create!(text: "Favorite fruits?", multiple_answers: true)
    @apple = @multi_choice_question.question_options.create!(text: "Apple")
    @banana = @multi_choice_question.question_options.create!(text: "Banana")
    @cherry = @multi_choice_question.question_options.create!(text: "Cherry")
  end

  test "can submit multiple answers for a multi-choice question" do
    assert_difference "QuestionResponse.count", 2 do
      post question_responses_path, params: { 
        question_id: @multi_choice_question.id, 
        question_option_ids: [@apple.id, @banana.id] 
      }
    end
    
    assert_redirected_to lesson_path(@lesson, page_id: @page.id)
    follow_redirect!
    assert_select "li", text: /Apple:.*1.*votes.*\(100.0%\).*<- Your choice/
    assert_select "li", text: /Banana:.*1.*votes.*\(100.0%\).*<- Your choice/
    assert_select "li", text: /Cherry:.*0.*votes.*\(0.0%\)/
  end

  test "can submit single answer for a single-choice question" do
    red_option = @single_choice_question.question_options.find_by(text: "Red")
    assert_difference "QuestionResponse.count", 1 do
      post question_responses_path, params: { 
        question_id: @single_choice_question.id, 
        question_option_id: red_option.id 
      }
    end
    
    assert_redirected_to lesson_path(@lesson, page_id: @page.id)
    follow_redirect!
    assert_select "li", text: /Red:.*1.*votes.*\(100.0%\).*<- Your choice/
  end

  test "submitting again replaces multiple answers" do
    post question_responses_path, params: { 
      question_id: @multi_choice_question.id, 
      question_option_ids: [@apple.id] 
    }
    
    assert_equal 1, @multi_choice_question.question_responses.count
    
    # Vote again with different options
    assert_no_difference "QuestionResponse.count" do # Destroys 1, creates 1
      post question_responses_path, params: { 
        question_id: @multi_choice_question.id, 
        question_option_ids: [@banana.id] 
      }
    end
    
    assert_equal 1, @multi_choice_question.question_responses.count
    assert_equal @banana, @multi_choice_question.question_responses.first.question_option
  end

  test "student can submit survey and see they have answered it" do
    # Go to student view
    get student_show_lesson_url(@lesson, page_id: @page.id)
    assert_response :success
    
    # Submit survey response from student view
    red_option = @single_choice_question.question_options.find_by(text: "Red")
    assert_difference "QuestionResponse.count", 1 do
      post question_responses_path, params: { 
        question_id: @single_choice_question.id, 
        question_option_id: red_option.id 
      }, headers: { "HTTP_REFERER" => student_show_lesson_url(@lesson, page_id: @page.id) }
    end
    
    # Should redirect back to student show
    assert_redirected_to student_show_lesson_url(@lesson, page_id: @page.id)
    follow_redirect!
    
    # Should see that they have answered
    assert_select "li", text: /Red:.*1.*votes.*\(100.0%\).*<- Your choice/
    assert_select "h3", "Survey"
  end
end
