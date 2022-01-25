class CreateJoinTableLocationOwner < ActiveRecord::Migration[6.1]
  def change
    create_join_table :locations, :users, table_name: 'location_owner' do |t|
      # t.index [:location_id, :user_id]
      # t.index [:user_id, :location_id]
    end
  end
end
