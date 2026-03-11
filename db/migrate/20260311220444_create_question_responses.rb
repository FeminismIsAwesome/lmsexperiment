class CreateQuestionResponses < ActiveRecord::Migration[8.1]
  def change
    create_table :question_responses do |t|
      t.references :question_option, null: false, foreign_key: true
      t.string :session_hash

      t.timestamps
    end
  end
end
