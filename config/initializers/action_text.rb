Rails.application.configure do
  # Configure Action Text sanitizer to allow iframes
  config.action_text.allowed_tags ||= []
  config.action_text.allowed_tags << "iframe"
  
  config.action_text.allowed_attributes ||= []
  config.action_text.allowed_attributes += ["src", "width", "height", "frameborder", "allow", "allowfullscreen", "title", "referrerpolicy"]
end
