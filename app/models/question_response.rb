class QuestionResponse < ApplicationRecord
  belongs_to :question_option, optional: true
  belongs_to :question
  validates :session_hash, uniqueness: { scope: [:question_id, :question_option_id] }, if: -> { question.multiple_choice? }
  validates :session_hash, uniqueness: { scope: [:question_id] }, if: -> { question.free_text? }
  validates :question_option, presence: true, if: -> { question.multiple_choice? }
  validates :answer_text, presence: true, if: -> { question.free_text? }
end
