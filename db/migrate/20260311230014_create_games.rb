class CreateGames < ActiveRecord::Migration[8.1]
  def change
    create_table :games do |t|
      t.references :lesson, null: false, foreign_key: true
      t.string :title
      t.string :game_type

      t.timestamps
    end
  end
end
