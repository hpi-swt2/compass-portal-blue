require 'rails_helper'

describe "I18n", type: :feature do

  it "has english as the default language", js: true do
    visit root_path
    # on the server (ruby)
    # This doesn't work: `expect(I18n.locale).to eq :en`
    # We expect ruby to change the .active class of the language switches
    expect(page).to have_selector('#language-switch-button-en.active')
    # Test that the ruby translations are correct
    expect(page).to have_css('#language-switch-button-en[title="English"]')
    expect(page).to have_css('#language-switch-button-de[title="German"]')
    # on the client (js)
    expect(evaluate_script('window.I18n.locale')).to eq 'en'
  end

  describe "switch language", type: :feature do

    it "changes the language to german when clicking the button", js: true do
      visit root_path
      click_on('DE')
      expect(evaluate_script('window.location.search')).to eq '?locale=de'
      # TODO: Works in the runtime, but not in the test:
      # expect(evaluate_script('I18n.locale')).to eq 'de'
    end

    it "correctly changes the language switch", js: true do
      visit root_path
      click_on('DE')
      expect(page).to have_selector('#language-switch-button-de.active')
      expect(page).not_to have_selector('#language-switch-button-en.active')
      expect(page).to have_css('#language-switch-button-en[title="Englisch"]')
      expect(page).to have_css('#language-switch-button-de[title="Deutsch"]')
    end
  end

  it "uses the language set via the locale query param", js: true do
    visit root_path(locale: 'de')
    expect(page).to have_selector('#language-switch-button-de.active')
    expect(evaluate_script('window.location.search')).to eq '?locale=de'
    expect(evaluate_script('window.I18n.locale')).to eq 'de'
  end
end
