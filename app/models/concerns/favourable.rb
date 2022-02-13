module Favourable
  extend ActiveSupport::Concern

  included do
    has_many :favourites, as: :favourable, dependent: :destroy
    has_many :favourited_by, through: :favourites, source: :user
  end
end
