class CreateJoinTableBuildingOwner < ActiveRecord::Migration[6.1]
  def change
    create_join_table :buildings, :users, table_name: 'building_owner' do |t|
      # t.index [:building_id, :user_id]
      # t.index [:user_id, :building_id]
    end
  end
end
