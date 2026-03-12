Rails.application.configure do
  config.after_initialize do
    # Configure Action Text sanitizer to allow iframes
    # We use a more robust check to ensure ActionText and its components are fully loaded
    if defined?(ActionText::Content) && ActionText::Content.respond_to?(:renderer) && ActionText::Content.renderer
      ActionText::Content.renderer.sanitize_options[:tags] << "iframe"
      ActionText::Content.renderer.sanitize_options[:attributes] << "src"
      ActionText::Content.renderer.sanitize_options[:attributes] << "width"
      ActionText::Content.renderer.sanitize_options[:attributes] << "height"
      ActionText::Content.renderer.sanitize_options[:attributes] << "frameborder"
      ActionText::Content.renderer.sanitize_options[:attributes] << "allow"
      ActionText::Content.renderer.sanitize_options[:attributes] << "allowfullscreen"
      ActionText::Content.renderer.sanitize_options[:attributes] << "title"
      ActionText::Content.renderer.sanitize_options[:attributes] << "referrerpolicy"
    end
  end
end
