class RemoveUserIdFromBuildings < ActiveRecord::Migration[6.1]
  def change
    remove_column :buildings, :user_id, :integer
  end
end
