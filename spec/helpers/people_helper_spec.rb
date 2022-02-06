require 'rails_helper'

describe PeopleHelper do
  before do
    @person = create :person
  end

  describe "tel_to" do
    it "makes a phone number clickable" do
      expected_link = (link_to @person.phone_number, "tel:#{@person.phone_number}")
      expect(tel_to(@person.phone_number)).to eq(expected_link)
    end
  end

  describe "mail_to" do
    it "makes an email address clickable" do
      expected_link = (link_to @person.email, "mailto:#{@person.email}")
      expect(mail_to(@person.email)).to eq(expected_link)
    end
  end
end
