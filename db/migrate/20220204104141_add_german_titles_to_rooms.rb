class AddGermanTitlesToRooms < ActiveRecord::Migration[6.1]
  def change
    add_column :rooms, :name_de, :string
  end
end
