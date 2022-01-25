class Building < ApplicationRecord
  has_and_belongs_to_many :owners, class_name: 'User', join_table: 'building_owner'
  include Timeable
  include Locateable
  validates :name, presence: true
end
