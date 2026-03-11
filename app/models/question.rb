class Question < ApplicationRecord
  belongs_to :page
  has_many :question_options, dependent: :destroy
  has_many :question_responses, dependent: :destroy
  validates :text, presence: true
  accepts_nested_attributes_for :question_options, allow_destroy: true, reject_if: :all_blank

  def total_respondents
    question_responses.distinct.count(:session_hash)
  end

  def response_percentage(option)
    return 0 if total_respondents == 0
    
    # For multiple answers, it's slightly more complex. 
    # Usually, for multi-select, you'd show % of people who selected this option.
    votes = question_responses.where(question_option: option).count
    (votes.to_f / total_respondents * 100).round(1)
  end
end
