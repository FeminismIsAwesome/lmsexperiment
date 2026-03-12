require "test_helper"

class PageTest < ActiveSupport::TestCase
  test "next_page and previous_page navigation" do
    lesson = Lesson.create!(title: "Test Lesson")
    page1 = Page.create!(lesson: lesson, title: "Page 1", content: "Content 1", position: 1)
    page2 = Page.create!(lesson: lesson, title: "Page 2", content: "Content 2", position: 2)
    page3 = Page.create!(lesson: lesson, title: "Page 3", content: "Content 3", position: 3)

    assert_equal page2, page1.next_page
    assert_equal page3, page2.next_page
    assert_nil page3.next_page

    assert_equal page2, page3.previous_page
    assert_equal page1, page2.previous_page
    assert_nil page1.previous_page
  end

  test "validations" do
    page = Page.new
    assert_not page.valid?
    assert_includes page.errors[:title], "can't be blank"
    assert_includes page.errors[:content], "can't be blank"
    assert_includes page.errors[:lesson], "must exist"
  end
end
