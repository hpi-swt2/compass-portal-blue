# Fix to allow use of Tod::TimeOfDay in combination with time type in database
ActiveModel::Type.register(:time_only, Tod::TimeOfDayType)
ActiveRecord::Type.register(:time_only, Tod::TimeOfDayType)

# Defines opening times for a day
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

  def day_as_string
    mapping = {
      0 => 'Monday',
      1 => 'Tuesday',
      2 => 'Wednesday',
      3 => 'Thursday',
      4 => 'Friday',
      5 => 'Saturday',
      6 => 'Sunday'
    }
    mapping[day]
  end

  private

  def opens_before_closes
    errors.add(:opens, "Should open before closing") unless opens && closes && opens < closes
  end

end
