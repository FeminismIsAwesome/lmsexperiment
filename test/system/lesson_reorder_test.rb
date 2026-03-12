require "application_system_test_case"

class LessonReorderTest < ApplicationSystemTestCase
  setup do
    @instructor = users(:one)
    @lesson = lessons(:one)
    # Ensure some items exist in the lesson for reordering
    @page1 = pages(:one)
    @page2 = pages(:two)
    # Give them consistent positions if not already set
    @page1.update!(position: 1)
    @page2.update!(position: 2)
    # Clear any other items that might be in the lesson from fixtures
    @lesson.pages.where.not(id: [@page1.id, @page2.id]).destroy_all
    @lesson.games.destroy_all
    
    login_as(@instructor)
  end

  # NOTE: If this test fails with a ChromeDriver version mismatch,
  # ensure your installed Chrome browser and ChromeDriver versions match.
  # This can often be resolved by running:
  #   brew install --cask chromedriver
  # Or by using a driver like :cuprite if available.
  test "reordering lesson items" do
    visit reorder_lesson_path(@lesson)

    assert_selector ".reorder-item", text: @page1.title
    assert_selector ".reorder-item", text: @page2.title

    # In modern JS-heavy apps, drag-and-drop can be tricky to simulate with standard Capybara methods.
    # We'll use a script to simulate the move if standard drag_to doesn't work,
    # but let's try the more "realistic" approach first if possible.
    
    source = find(".reorder-item[data-id='#{@page1.id}'][data-type='Page'] .drag-handle")
    target = find(".reorder-item[data-id='#{@page2.id}'][data-type='Page']")

    # This is the most common way to simulate drag and drop in Capybara/Selenium
    # But it often fails with SortableJS, so we also provide a JS-based alternative.
    # Force fallback for testing as standard drag_to is unreliable with SortableJS
    simulate_drag_and_drop(source, target)
    
    # Giving it a moment for the PATCH request to fire and finish
    sleep 2
    
    assert_equal 2, @page1.reload.position
    assert_equal 1, @page2.reload.position
  end

  private

  def simulate_drag_and_drop(source, target)
    # Simple script to trigger sortable's reorder
    page.execute_script(<<~JS, source.native, target.native)
      const sourceHandle = arguments[0];
      const targetItem = arguments[1];
      const sourceItem = sourceHandle.closest('.reorder-item');
      const container = sourceItem.closest('.reorder-list');
      
      // Move source after target in DOM
      targetItem.parentNode.insertBefore(sourceItem, targetItem.nextSibling);
      
      // Manually trigger the Stimulus controller's onEnd logic
      // We search for the controller in the Stimulus application
      const app = window.Stimulus
      if (app) {
        const controller = app.getControllerForElementAndIdentifier(container, 'reorder')
        if (controller) {
          controller.onEnd({ item: sourceItem });
        }
      }
    JS
  end
end
