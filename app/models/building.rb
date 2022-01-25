class Building < ApplicationRecord
  has_and_belongs_to_many :users
  include Timeable
  include Locateable
  validates :name, presence: true
end
