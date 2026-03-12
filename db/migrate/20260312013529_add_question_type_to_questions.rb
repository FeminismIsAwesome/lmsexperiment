class AddQuestionTypeToQuestions < ActiveRecord::Migration[8.1]
  def change
    add_column :questions, :question_type, :string, default: "multiple_choice", null: false
  end
end
