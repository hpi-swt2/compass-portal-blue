class DropContactPersonFromRoom < ActiveRecord::Migration[6.1]
  def change
    remove_column :rooms, :contact_person, :string
  end
end
