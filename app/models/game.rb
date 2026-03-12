class Game < ApplicationRecord
  belongs_to :lesson
  has_many :events, dependent: :destroy

  validates :title, :game_type, :position, presence: true

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
end
