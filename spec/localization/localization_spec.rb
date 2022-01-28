require 'rails_helper'

describe "I18n", type: :feature do

  it "should have english as the default language", js: true do
    visit root_path
    # on the server (ruby)
    expect(I18n.locale).to eq :en
    # on the client (js)
    expect(evaluate_script('window.I18n.locale')).to eq 'en'
  end

  it "should change the language to german when clicking the button", js: true do
    visit root_path
    click_on('DE')
    expect(I18n.locale).to eq :de
    expect(evaluate_script('window.I18n.locale')).to eq 'de'
  end

  it "should respect the language set via the locale query param", js: true do
    visit root_path(locale: 'de')
    expect(evaluate_script('window.location.search')).to eq '?locale=de'
    expect(I18n.locale).to eq :de
    expect(evaluate_script('window.I18n.locale')).to eq 'de'
  end
end
