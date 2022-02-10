class ChangeFloorToIntegerFromRoom < ActiveRecord::Migration[6.1]
  def up
    change_column :rooms, :floor, :integer, using: 'floor::integer'
  end

  def down
    change_column :rooms, :floor, :string
  end
end
