class Favourite < ApplicationRecord
  belongs_to :favourable, polymorphic: true
  belongs_to :user
end
