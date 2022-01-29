class CreateJoinTablelePersonOwner < ActiveRecord::Migration[6.1]
  def change
    create_join_table :people, :users, table_name: 'person_owner' do |t|
      # t.index [:person_id, :owner_id]
      # t.index [:owner_id, :person_id]
    end
  end
end
