class Building < ApplicationRecord
  include Timeable
  include Locateable
  validates :name, presence: true
end
