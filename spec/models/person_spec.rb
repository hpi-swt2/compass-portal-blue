require 'rails_helper'

RSpec.describe Person, type: :model do
  it "has first_name, last_name, phone_number, email" do
    person = create :person
    expect(person.first_name).to eq("Herbert")
    expect(person.last_name).to eq("Herbertson")
    expect(person.phone_number).to eq("+4990909090")
    expect(person.email).to eq("herbert.herbertson@hpi.de")
  end
end
