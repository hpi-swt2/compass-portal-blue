# The model representing a user who can log in
class User < ApplicationRecord
  belongs_to :person, dependent: :destroy

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
    return unless person.nil?

    self.person = Person.new
    person.email = email
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

  private

  private_class_method def self.read_auth_data_into_user(user, auth)
    user.email = auth.info.email
    user.username = auth.info.name
    user.person = Person.from_omniauth(auth)
  end
end
