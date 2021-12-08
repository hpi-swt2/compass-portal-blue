require 'rails_helper'

RSpec.describe Assignment, type: :model do
  role1 = FactoryBot.build :role
  user1 = FactoryBot.build :user
  assignment = Assignment.new(user: user1, role: role1)

  it "has role" do
    expect(assignment.role).to eq role1
  end

  it "has user" do
    expect(assignment.user).to eq user1
  end
end
