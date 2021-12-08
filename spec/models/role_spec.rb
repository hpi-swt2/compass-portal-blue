require 'rails_helper'

RSpec.describe Role, type: :model do
  role = FactoryBot.build :role

  describe "attribute check" do
    it "has name" do
      expect(role.name).to eq 'admin'
    end
  end

  describe "relationships" do
    it "has an assignment" do
      role = described_class.reflect_on_association(:assignments)
      expect(role.macro).to eq :has_many
    end
  end
  
end
