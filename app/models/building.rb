class Building < ApplicationRecord
  belongs_to :user
  include Timeable
  include Locateable
  validates :name, presence: true
end
