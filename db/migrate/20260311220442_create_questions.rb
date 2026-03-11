class CreateQuestions < ActiveRecord::Migration[8.1]
  def change
    create_table :questions do |t|
      t.references :page, null: false, foreign_key: true
      t.string :text

      t.timestamps
    end
  end
end
