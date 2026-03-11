class CreateEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :events do |t|
      t.references :game, null: false, foreign_key: true
      t.string :session_hash
      t.string :event_type

      t.timestamps
    end
  end
end
