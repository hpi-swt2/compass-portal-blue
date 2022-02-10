require 'rails_helper'

RSpec.describe Person, type: :model do
  it "has first_name, last_name, phone_number, email" do
    person = create :person
    expect(person.first_name).to eq("Herbert")
    expect(person.last_name).to eq("Herbertson")
    expect(person.phone_number).to eq("+4990909090")
    expect(person.email).to eq("herbert.herbertson@hpi.de")
  end

  it "has formats the phone number" do
    person = create :person
    expect(person.formatted_phone_number).to eq("+49 9090 9090")
  end

  it "can be created from omniauth" do
    stub_const("Info", Struct.new(:first_name, :last_name, :email))
    stub_const("Auth", Struct.new(:info))
    info = Info.new("Herbert", "Herbertson", "herbert.herbertson@hpi.de")
    auth = Auth.new(info)
    person = described_class.from_omniauth(auth)
    expect(person.first_name).to eq("Herbert")
    expect(person.last_name).to eq("Herbertson")
    expect(person.email).to eq("herbert.herbertson@hpi.de")
  end
end
