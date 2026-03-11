class QuestionOption < ApplicationRecord
  belongs_to :question
  has_many :question_responses, dependent: :destroy
  validates :text, presence: true
end
