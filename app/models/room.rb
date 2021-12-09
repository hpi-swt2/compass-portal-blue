class Room < ApplicationRecord
  belongs_to :building
  has_and_belongs_to_many :users
  validates :name, :floor, presence: true
end
