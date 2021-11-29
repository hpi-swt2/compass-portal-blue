class AddBuildingsToRooms < ActiveRecord::Migration[6.1]
  def change
    add_reference :rooms, :building, null: false, foreign_key: true
  end
end
