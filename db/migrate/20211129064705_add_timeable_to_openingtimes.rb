class AddTimeableToOpeningtimes < ActiveRecord::Migration[6.1]
  def change
    add_reference :openingtimes, :timeable, polymorphic: true, null: true, index: true
  end
end
