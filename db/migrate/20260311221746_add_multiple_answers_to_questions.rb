class AddMultipleAnswersToQuestions < ActiveRecord::Migration[8.1]
  def change
    add_column :questions, :multiple_answers, :boolean, default: false, null: false
  end
end
