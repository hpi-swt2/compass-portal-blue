require 'rails_helper'

RSpec.describe Role, type: :model do
  role = FactoryBot.create :role

  it "has name" do
    expect(role.name).to eq 'admin'
  end
  
end
