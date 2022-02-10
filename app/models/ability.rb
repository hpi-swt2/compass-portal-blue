# frozen_string_literal: true

# An ability of a user
class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      if user.admin?
        initialize_admin
      else
        initialize_user user
      end
    else
      initialize_guest
    end
  end

  def initialize_admin
    can :manage, :all
  end

  def initialize_user(user)
    can :create, Location
    can :manage, Location, owners: { id: user.id }
    can :create, Building
    can :manage, Building, owners: { id: user.id }
    can :create, Room
    can :manage, Room, owners: { id: user.id }
    can :create, Person
    can :manage, Person, owners: { id: user.id }
    can :read, :all
  end

  def initialize_guest
    can :read, :all
  end
end
