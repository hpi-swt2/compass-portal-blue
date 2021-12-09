class Person < ApplicationRecord
  include Timeable

  validates :phone_number, phone: true, allow_blank: true
  before_save :normalize_phone_number
  has_one_attached :profile_picture
  has_and_belongs_to_many :rooms

  accepts_nested_attributes_for :openingtimes, allow_destroy: true

  def initialize(params = {})
    super(params)
    #self.first_name = params.fetch(:first_name, '')
    #self.last_name = last_name
    #self.email = email
    #self.phone_number = phone_number

    # Uncomment, if you are using confirmable and the provider(s) you use validate emails:
    # user.skip_confirmation!
    #self.profile_picture.attach(
    #  io: File.open('app/assets/images/default-profile-picture.png'),
    #  filename: 'default-profile-picture.png',
    #  content_type: 'image/png'
    #)
  end

  def formatted_phone_number
    parsed_phone = Phonelib.parse(phone_number)
    return phone_number if parsed_phone.invalid?

    parsed_phone.full_international
  end

  def name
    return "#{first_name} #{last_name}"
  end

  private

  def normalize_phone_number
    self.phone_number = Phonelib.parse(phone_number).full_e164.presence
  end
end
