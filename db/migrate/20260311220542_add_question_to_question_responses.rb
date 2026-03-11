class AddQuestionToQuestionResponses < ActiveRecord::Migration[8.1]
  def change
    add_reference :question_responses, :question, null: false, foreign_key: true
  end
end
