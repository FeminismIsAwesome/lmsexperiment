class Lesson < ApplicationRecord
  has_many :pages, -> { order(position: :asc) }, dependent: :destroy
  has_many :games, dependent: :destroy
  validates :title, presence: true
end
