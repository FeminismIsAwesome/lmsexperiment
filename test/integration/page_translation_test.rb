require "test_helper"

class PageTranslationTest < ActionDispatch::IntegrationTest
  setup do
    @lesson = Lesson.create!(title: "Translation Lesson")
    @user = users(:one)
    sign_in @user
  end

  test "should create page with multiple translations" do
    assert_difference "Page.count", 1 do
      assert_difference "PageTranslation.count", 2 do
        post pages_path, params: {
          page: {
            lesson_id: @lesson.id,
            title: "English Title",
            content: "English Content",
            page_translations_attributes: [
              { locale: "es", title: "Spanish Title", content: "Spanish Content" },
              { locale: "fr", title: "French Title", content: "French Content" }
            ]
          }
        }
      end
    end

    @page = Page.last
    
    # Default locale (en) should show the Page's title/content (or its 'en' translation)
    get lesson_path(@lesson, page_id: @page.id)
    assert_response :success
    assert_match /English Title/, response.body
    assert_match /English Content/, response.body

    # Spanish locale
    get lesson_path(@lesson, page_id: @page.id, locale: "es")
    assert_response :success
    assert_match /Spanish Title/, response.body
    assert_match /Spanish Content/, response.body

    # French locale
    get lesson_path(@lesson, page_id: @page.id, locale: "fr")
    assert_response :success
    assert_match /French Title/, response.body
    assert_match /French Content/, response.body
  end

  test "should update page translations" do
    @page = Page.create!(lesson: @lesson, title: "Original Title", content: "Original Content")
    @translation = PageTranslation.create!(page: @page, locale: "es", title: "Original Spanish", content: "Original Spanish Content")

    patch page_url(@page), params: {
      page: {
        page_translations_attributes: [
          { id: @translation.id, title: "Updated Spanish", content: "Updated Spanish Content" }
        ]
      }
    }

    assert_redirected_to lesson_url(@lesson, page_id: @page.id)
    @translation.reload
    assert_equal "Updated Spanish", @translation.title
    assert_match /Updated Spanish Content/, @translation.content.to_s
  end
end
