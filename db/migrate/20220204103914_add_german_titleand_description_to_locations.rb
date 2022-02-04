class AddGermanTitleandDescriptionToLocations < ActiveRecord::Migration[6.1]
  def change
    add_column :locations, :name_de, :string
    add_column :locations, :details_de, :text
  end
end
