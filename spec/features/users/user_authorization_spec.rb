require 'cancan/matchers'
require 'rails_helper'

describe 'User authorization', type: :feature do
    it "should be possible for an Admin can manage location, people and building" do
        @user = FactoryBot.create(:user, admin: true)
        ability = Ability.new(@user)
        expect(ability).to be_able_to(:manage, Location.new(user: @user)) # location

        expect(ability).to be_able_to(:manage, Building.new(user: @user)) # building
    end

    it "should not be possible for user without Admin permission to manage location, people and building" do
        @user = FactoryBot.create(:user, admin: false)
        @building = FactoryBot.create :building
        @location = FactoryBot.create :location

        ability = Ability.new(@user)
        expect(ability).not_to be_able_to(:manage, @location)
        expect(ability).not_to be_able_to(:manage, @building)
    end

    it "should be possible as user without Admin permission to update and delete an own location, people and building" do
        @user = FactoryBot.create(:user, admin: false)
        ability = Ability.new(@user)
        expect(ability).to be_able_to(:manage, Location.new(user: @user)) # location
        expect(ability).to be_able_to(:manage, Building.new(user: @user)) # building
    end

  end