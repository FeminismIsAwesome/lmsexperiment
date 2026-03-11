class QuestionResponse < ApplicationRecord
  belongs_to :question_option
  belongs_to :question
  validates :session_hash, uniqueness: { scope: [:question_id, :question_option_id] }
end
