class CreateOpeningtimes < ActiveRecord::Migration[6.1]
  def change
    create_table :openingtimes do |t|
      t.time :opens
      t.time :closes
      t.integer :day

      t.timestamps
    end
  end
end
