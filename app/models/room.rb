class Room < ApplicationRecord
  belongs_to :building
  has_and_belongs_to_many :users
end
