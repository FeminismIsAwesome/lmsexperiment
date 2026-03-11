class CreatePageViews < ActiveRecord::Migration[8.1]
  def change
    create_table :page_views do |t|
      t.references :page, null: false, foreign_key: true
      t.string :session_hash

      t.timestamps
    end
  end
end
