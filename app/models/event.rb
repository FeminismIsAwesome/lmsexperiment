class Event < ApplicationRecord
  belongs_to :game

  validates :event_type, presence: true, inclusion: { in: %w[start completed engaged] }
  validates :session_hash, presence: true
end
