ActiveModel::Type.register(:time_only, Tod::TimeOfDayType)
ActiveRecord::Type.register(:time_only, Tod::TimeOfDayType)

class Openingtime < ApplicationRecord
  belongs_to :timeable, polymorphic: true
  attribute :opens, :time_only
  attribute :closes, :time_only
  validates :day, \
            presence: true, \
            numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 6 }
  validates :opens, presence: true
  validates :closes, presence: true
  validate :opens_before_closes

  private

  def opens_before_closes
    errors.add(:opens, "Should open before closing") unless opens < closes
  end
end
