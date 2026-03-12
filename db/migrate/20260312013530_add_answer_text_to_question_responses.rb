class AddAnswerTextToQuestionResponses < ActiveRecord::Migration[8.1]
  def change
    add_column :question_responses, :answer_text, :text
  end
end
