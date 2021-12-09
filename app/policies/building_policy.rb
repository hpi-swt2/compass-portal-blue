class BuildingPolicy < ApplicationPolicy
    def index?
      true
    end

    def update?
      user.role? :admin 
    end

    def create?
      user.role? :admin 
    end

    def destroy?
      user.role? :admin 
    end
  end
  