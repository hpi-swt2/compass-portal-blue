class RemovePersonDataFromUser < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :phone_number
    remove_column :users, :first_name
    remove_column :users, :last_name
  end
end
