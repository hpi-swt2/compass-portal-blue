module Timeable
  extend ActiveSupport::Concern

  included do
    has_many :openingtimes, as: :timeable, dependent: :nullify
  end
end
