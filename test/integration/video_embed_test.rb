require "test_helper"

class VideoEmbedTest < ActionDispatch::IntegrationTest
  setup do
    @lesson = Lesson.create!(title: "Video Lesson")
    @user = users(:one)
    sign_in @user
  end

  test "should render iframe for video embeds" do
    iframe_code = '<iframe width="640" height="360" src="https://www.youtube.com/embed/JegGjYtstyw" title="Video" frameborder="0" allowfullscreen></iframe>'
    
    assert_difference "Page.count", 1 do
      post pages_path, params: {
        page: {
          lesson_id: @lesson.id,
          title: "Page with Video",
          content: "<div>#{iframe_code}</div>",
          position: 1
        }
      }
    end
    
    @page = Page.order(created_at: :desc).first
    assert_equal @lesson.id, @page.lesson_id, "Page should be associated with the correct lesson"
    get lesson_path(@lesson, page_id: @page.id)
    
    assert_response :success
    # Check if iframe is present and wrapped in video-container
    assert_select "div.video-container" do
      assert_select "iframe[src='https://www.youtube.com/embed/JegGjYtstyw']"
    end
  end

  test "should handle escaped iframe and render it" do
    # This simulates what happens if it's pasted as text into Trix
    escaped_iframe = '&lt;iframe src="https://www.youtube.com/embed/JegGjYtstyw"&gt;&lt;/iframe&gt;'
    
    post pages_path, params: {
      page: {
        lesson_id: @lesson.id,
        title: "Page with Escaped Video",
        content: "<div>#{escaped_iframe}</div>",
        position: 2
      }
    }
    
    @page = Page.last
    get lesson_path(@lesson, page_id: @page.id)
    
    assert_response :success
    # Should be unescaped and wrapped
    assert_select "div.video-container" do
      assert_select "iframe[src='https://www.youtube.com/embed/JegGjYtstyw']"
    end
  end
end
