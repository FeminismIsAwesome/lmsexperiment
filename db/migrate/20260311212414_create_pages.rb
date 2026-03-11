class CreatePages < ActiveRecord::Migration[8.1]
  def change
    create_table :pages do |t|
      t.references :lesson, null: false, foreign_key: true
      t.string :title
      t.text :content
      t.integer :position

      t.timestamps
    end
  end
end
