class Game < ApplicationRecord
  belongs_to :lesson
  has_many :events, dependent: :destroy

  before_validation :set_default_position
  validates :title, :game_type, presence: true

  DEFAULT_WORDS = ["Honest", "trust", "equality", "boundaries", "communication", "respect"].freeze

  DEFAULT_CATEGORIES = {
    "categories" => [
      { "name" => "Fruits", "id" => "fruits" },
      { "name" => "Veggies", "id" => "veggies" }
    ],
    "items" => [
      { "name" => "Apple", "category" => "fruits", "image" => "https://images.unsplash.com/photo-1560806887-1e4cd0b6bcd6?w=200" },
      { "name" => "Banana", "category" => "fruits", "image" => "https://images.unsplash.com/photo-1571771894821-ad9902d73647?w=200" },
      { "name" => "Carrot", "category" => "veggies", "image" => "https://images.unsplash.com/photo-1598170845058-32b9d6a5da37?w=200" },
      { "name" => "Broccoli", "category" => "veggies", "image" => "https://images.unsplash.com/photo-1459411621453-7b03977f4bfc?w=200" }
    ],
    "time_limit" => 30,
    "points_per_item" => 1
  }.freeze

  def memory_match_words
    return DEFAULT_WORDS if options.blank? || options["words"].blank?
    
    words = options["words"]
    words = words.split(",").map(&:strip) if words.is_a?(String)
    words
  end

  def categorize_options
    return DEFAULT_CATEGORIES if options.blank?
    
    # Ensure categories and items are present, otherwise merge with defaults
    merged = DEFAULT_CATEGORIES.merge(options)
    merged["categories"] = DEFAULT_CATEGORIES["categories"] if merged["categories"].blank?
    merged["items"] = DEFAULT_CATEGORIES["items"] if merged["items"].blank?
    
    # Ensure numeric values are integers
    merged["time_limit"] = merged["time_limit"].to_i if merged["time_limit"].present?
    merged["points_per_item"] = merged["points_per_item"].to_i if merged["points_per_item"].present?
    
    merged
  end

  def unique_starts
    events.where(event_type: "start").distinct.count(:session_hash)
  end

  def unique_completions
    events.where(event_type: "completed").distinct.count(:session_hash)
  end

  def unique_engagements
    events.where(event_type: "engaged").distinct.count(:session_hash)
  end
  def set_default_position
    return if position.present?
    return if lesson.nil?

    max_position = [
      lesson.pages.maximum(:position) || 0,
      lesson.games.maximum(:position) || 0
    ].max
    self.position = max_position + 1
  end
end
