module Timeable
  extend ActiveSupport::Concern

  included do
    has_many :openingtimes, as: :timeable
  end
end
