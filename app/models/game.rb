class Game < ApplicationRecord
  belongs_to :lesson
  has_many :events, dependent: :destroy

  before_validation :set_default_position
  validates :title, :game_type, presence: true

  DEFAULT_WORDS = ["Honest", "trust", "equality", "boundaries", "communication", "respect"].freeze

  def memory_match_words
    return DEFAULT_WORDS if options.blank? || options["words"].blank?
    
    words = options["words"]
    words = words.split(",").map(&:strip) if words.is_a?(String)
    words
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
