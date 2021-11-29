class Openingtime < ApplicationRecord
  belongs_to :timeable, polymorphic: true
end
