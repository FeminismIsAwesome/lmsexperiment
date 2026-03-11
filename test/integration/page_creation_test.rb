require "test_helper"

class PageCreationTest < ActionDispatch::IntegrationTest
  setup do
    @lesson = Lesson.create!(title: "Creation Lesson")
    sign_in users(:one)
  end

  test "should create page with survey questions and options" do
    assert_difference -> { Page.count } => 1, -> { Question.count } => 1, -> { QuestionOption.count } => 3 do
      post pages_path, params: {
        page: {
          lesson_id: @lesson.id,
          title: "New Page with Survey",
          content: "Some content",
          position: 1,
          questions_attributes: {
            "0" => {
              text: "First Question?",
              multiple_answers: false,
              question_options_attributes: {
                "0" => { text: "Option 1" },
                "1" => { text: "Option 2" },
                "2" => { text: "Option 3" }
              }
            }
          }
        }
      }
    end

    assert_redirected_to lesson_path(@lesson, page_id: Page.last.id)
    follow_redirect!
    assert_select "h3", "Survey"
    assert_select "p", text: "First Question?"
    assert_select "li", /Option 1: 0 votes \(0%\)/
    assert_select "li", /Option 2: 0 votes \(0%\)/
    assert_select "li", /Option 3: 0 votes \(0%\)/
  end

  test "should update page and preserve questions and options" do
    page = Page.create!(lesson: @lesson, title: "Initial Page", content: "Content", position: 1)
    question = page.questions.create!(text: "Old Question")
    option = question.question_options.create!(text: "Old Option")

    assert_no_difference "Question.count" do
      patch page_path(page), params: {
        page: {
          questions_attributes: {
            "0" => {
              id: question.id,
              text: "Updated Question",
              question_options_attributes: {
                "0" => { id: option.id, text: "Updated Option" }
              }
            }
          }
        }
      }
    end

    assert_redirected_to lesson_path(@lesson, page_id: page.id)
    question.reload
    option.reload
    assert_equal "Updated Question", question.text
    assert_equal "Updated Option", option.text
  end
end
