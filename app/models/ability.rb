# frozen_string_literal: true

# An ability of a person
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.admin?
      initialize_admin
    elsif user.present?
      initialize_user user
    else
      initialize_guest
    end
  end

  def initialize_admin
    can :manage, :all
  end

  def initialize_user(user)
    can :manage, Location, owners: { id: user.id }
    can :manage, Building, owners: { id: user.id }
    can :manage, Room, owners: { id: user.id }
    can :manage, Person, owners: { id: user.id }
    can :read, :all
  end

  def initialize_guest
    can :read, :all
  end
end
