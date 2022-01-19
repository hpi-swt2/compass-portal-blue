require "rails_helper"

describe "Search Suggestions", type: :feature do
    before do
        Capybara.current_driver = :selenium_chrome_headless
        Capybara.ignore_hidden_elements = false
    end

    after do
        Capybara.current_driver = :default
    end

    it "has empty history on start", js:true do
        visit "/"
        find("#search", wait: 5).click()
        expect(page).to have_no_xpath("/div[@class='historyDiv']/li")
    end



end