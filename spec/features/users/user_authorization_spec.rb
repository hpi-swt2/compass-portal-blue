require 'cancan/matchers'
require 'rails_helper'

describe 'User authorization', type: :feature do
  it "is possible for an Admin to manage person, location and building" do
    @user = create(:user, admin: true)
    ability = Ability.new(@user)
    expect(ability).to be_able_to(:manage, Location.new(users: [@user])) # location
    expect(ability).to be_able_to(:manage, Building.new(users: [@user])) # building
    expect(ability).to be_able_to(:manage, Person.new(owners: [@user])) # person
  end

  it "is not possible for user without Admin permission to manage person, location and building" do
    @user = create(:user, admin: false)
    @building = create :building
    @location = create :location
    @person = create :person

    ability = Ability.new(@user)
    expect(ability).not_to be_able_to(:manage, @location)
    expect(ability).not_to be_able_to(:manage, @building)
    expect(ability).not_to be_able_to(:manage, @person)
  end

  it "is possible as user without Admin permission to update and delete an own person, location and building" do
    @user = create(:user, admin: false)
    ability = Ability.new(@user)
    expect(ability).to be_able_to(:manage, Location.new(users: [@user])) # location
    expect(ability).to be_able_to(:manage, Building.new(users: [@user])) # building
    expect(ability).to be_able_to(:manage, Person.new(owners: [@user])) # person
  end

  it "is possible for a user to update and delete his own person" do
    @user = create(:user, admin: false)
    ability = Ability.new(@user)
    expect(ability).to be_able_to(:manage, @user.person)
  end

end
