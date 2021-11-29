require 'rails_helper'

RSpec.describe Openingtime, type: :model do
  openingtime = FactoryBot.create(:openingtime)
  expect(openingtime.day).to eq (1)
end
