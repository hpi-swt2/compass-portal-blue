class AddGermanTitlesToBuildings < ActiveRecord::Migration[6.1]
  def change
    add_column :buildings, :name_de, :string
  end
end
