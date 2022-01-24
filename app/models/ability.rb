# frozen_string_literal: true

# An ability of a person
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.admin?
      can :manage, :all
    elsif user.present?
      can :manage, Location, user_id: user.id
      can :manage, Building, user_id: user.id
      can :read, :all
    else
      can :read, :all
    end
  end
end
