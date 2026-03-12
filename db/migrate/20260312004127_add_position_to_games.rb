class AddPositionToGames < ActiveRecord::Migration[8.1]
  def change
    add_column :games, :position, :integer
  end
end
