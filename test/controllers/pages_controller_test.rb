require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @page = pages(:one)
    sign_in users(:one)
  end

  test "should get index" do
    get pages_url
    assert_response :success
  end

  test "should get new" do
    get new_page_url
    assert_response :success
  end

  test "should create page" do
    assert_difference("Page.count") do
      post pages_url, params: { page: { content: "New Content", lesson_id: @page.lesson_id, position: 3, title: "New Page" } }
    end

    assert_redirected_to lesson_url(@page.lesson, page_id: Page.last.id)
  end

  test "should show page" do
    get page_url(@page)
    assert_response :success
  end

  test "should get edit" do
    get edit_page_url(@page)
    assert_response :success
  end

  test "should update page" do
    patch page_url(@page), params: { page: { content: "Updated Content", lesson_id: @page.lesson_id, position: @page.position, title: @page.title } }
    assert_redirected_to lesson_url(@page.lesson, page_id: @page.id)
  end

  test "should destroy page" do
    assert_difference("Page.count", -1) do
      delete page_url(@page)
    end

    assert_redirected_to pages_url
  end
end
