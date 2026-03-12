class Event < ApplicationRecord
  belongs_to :game

  validates :event_type, presence: true, inclusion: { in: %w[start completed engaged visit] }
  validates :session_hash, presence: true
end
