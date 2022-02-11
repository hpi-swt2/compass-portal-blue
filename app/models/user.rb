require "date"

CLEANER_TASK_INTERVAL = 5 * 60 # 5 minutes
CLEANER_ENTRY_TIMEOUT_MINUTES = 10

# The model representing a user who can log in
class User < ApplicationRecord
  belongs_to :person, dependent: :destroy
  has_and_belongs_to_many :owned_locations, class_name: 'Location', join_table: 'location_owner'
  has_and_belongs_to_many :owned_buildings, class_name: 'Building', join_table: 'building_owner'
  has_and_belongs_to_many :owned_rooms, class_name: 'Room', join_table: 'room_owner'
  has_and_belongs_to_many :owned_people, class_name: 'Person', join_table: 'person_owner'
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :omniauthable,
         omniauth_providers: %i[openid_connect]

  def initialize(attributes = {})
    super(attributes)
    if person.nil?
      self.person = Person.new
      person.email = email
    end
    person.owners = [self]
  end

  # Called from app/controllers/users/omniauth_callbacks_controller.rb
  # Match OpenID Connect data to a local user object
  def self.from_omniauth(auth)
    # Check if user with provider ('openid_connect') and uid is in db, otherwise create it
    where(provider: auth.provider, uid: auth.uid).first_or_create! do |user|
      # All information returned by OpenID Connect is passed in `auth` param

      # Generate random password, default length is 20
      # https://www.rubydoc.info/github/plataformatec/devise/Devise.friendly_token
      user.password = Devise.friendly_token[0, 20]

      read_auth_data_into_user(user, auth)
    end
  end

  # https://github.com/heartcombo/devise/wiki/OmniAuth:-Overview
  # Implement the following if you want to enable copying over data from an
  # OmniAuth provider after a user alsready has a session, i.e. is already logged in
  # def self.new_with_session(params, session)
  #   super.tap do |user|
  #     if (data = session["devise.openid_connect_data"]) && user.email.blank?
  #       user.email = data["email"]
  #     end
  #   end
  # end

  # Maps from user ids to (location, timestamp) tuples
  @locations = Concurrent::Hash.new

  unless Rails.env.test?
    @cleaner_task = Concurrent::TimerTask.execute(execution_interval: CLEANER_TASK_INTERVAL) do
      User.clean_outdated_locations
    end
  end

  class << self
    attr_accessor :locations, :cleaner_task
  end

  def update_last_known_location(location)
    self.class.locations[id] = [location, DateTime.now]
  end

  def last_known_location_with_timestamp
    self.class.locations[id]
  end

  def last_known_location
    last_known_location_with_timestamp&.at(0)
  end

  def delete_last_known_location
    self.class.locations.delete id
  end

  def self.clean_outdated_locations
    logger.info "Cleaning `User.locations` ..."

    locations.reject! do |_, (_, insertion_time)|
      insertion_time < DateTime.now.advance(minutes: -CLEANER_ENTRY_TIMEOUT_MINUTES)
    end
  end

  private

  private_class_method def self.read_auth_data_into_user(user, auth)
    user.email = auth.info.email
    user.username = auth.info.name
    user.person = Person.from_omniauth(auth)
  end
end
