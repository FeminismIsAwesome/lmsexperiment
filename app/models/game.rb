class Game < ApplicationRecord
  belongs_to :lesson
  has_many :events, dependent: :destroy

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
