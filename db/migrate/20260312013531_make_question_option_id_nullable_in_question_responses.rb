class MakeQuestionOptionIdNullableInQuestionResponses < ActiveRecord::Migration[8.1]
  def change
    change_column_null :question_responses, :question_option_id, true
  end
end
