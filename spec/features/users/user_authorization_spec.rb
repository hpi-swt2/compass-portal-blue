require 'cancan/matchers'
require 'rails_helper'

describe 'User authorization', type: :feature do
  it "is possible for an Admin can manage location, people and building" do
    @user = create(:user, admin: true)
    ability = Ability.new(@user)
    expect(ability).to be_able_to(:manage, Location.new(users: [@user])) # location

    expect(ability).to be_able_to(:manage, Building.new(users: [@user])) # building
  end

  it "is not possible for user without Admin permission to manage location, people and building" do
    @user = create(:user, admin: false)
    @building = create :building
    @location = create :location

    ability = Ability.new(@user)
    expect(ability).not_to be_able_to(:manage, @location)
    expect(ability).not_to be_able_to(:manage, @building)
  end

  it "is possible as user without Admin permission to update and delete an own location, people and building" do
    @user = create(:user, admin: false)
    ability = Ability.new(@user)
    expect(ability).to be_able_to(:manage, Location.new(users: [@user])) # location
    expect(ability).to be_able_to(:manage, Building.new(users: [@user])) # building
  end

end
