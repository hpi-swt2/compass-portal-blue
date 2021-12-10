class Room < ApplicationRecord
  belongs_to :building
  has_and_belongs_to_many :users
  validates :name, presence: true
  validates :floor, presence: true, numericality: { only_integer: true }
end
