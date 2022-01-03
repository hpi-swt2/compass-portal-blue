class RemovePersonDataFromUser < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :phone_number, :string
    remove_column :users, :first_name, :string
    remove_column :users, :last_name, :string
  end
end
