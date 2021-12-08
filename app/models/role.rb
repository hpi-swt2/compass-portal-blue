class Role < ApplicationRecord
    validates :name, presence: true#, uniqueness: true #works not in tests
end
