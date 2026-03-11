class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  helper_method :session_hash

  private

  def session_hash
    session[:visitor_id] ||= SecureRandom.hex(16)
    Digest::SHA256.hexdigest(session[:visitor_id])
  end
end
