require "rails_helper"

describe "Search Suggestions", type: :feature do
    before do
        Capybara.current_driver = :selenium_chrome_headless
        Capybara.ignore_hidden_elements = false
        @building_1 = FactoryBot.create :building, name: "Building1"
        @building_2 = FactoryBot.create :building, name: "Building2"
        @building_3 = FactoryBot.create :building, name: "Building3"
        @building_4 = FactoryBot.create :building, name: "Building4"
        @building_5 = FactoryBot.create :building, name: "Building5"
        @building_6 = FactoryBot.create :building, name: "Building6"
    end

    after do
        Capybara.current_driver = :default
    end

    it "has empty history on start", js:true do
        visit "/"
        find("#search", wait: 5).click()
        expect(page).to have_no_xpath("//div[@class='historyDiv']/li")
    end

    it "adds a clicked search result to history & shows it", js:true do
        visit search_results_path(query: "b")
        result = find(:xpath, "//a[@class='search_result_title']", match: :first, wait: 5)
        link = result["href"]
        result.click()
        visit "/"
        find("#search", wait: 5).click()
        expect(page).to have_xpath("//div[@id='historyDiv']/li")
        expect(page).to have_xpath("//a[contains(@href, '" + link + "')]")
    end

    it "drops the oldest history entry", js:true do
        for building_number in [1, 2, 3, 4, 5, 6] do
            visit search_results_path(query: "Building"+format("%d", building_number))
            find(:xpath, "//a[@class='search_result_title']", wait: 5).click()
        end
        visit "/"
        find("#search", wait: 5).click()
        for remaining_number in [2, 3, 4, 5, 6] do
            expect(page).to have_xpath("//a[text()='Building" + format("%d", remaining_number) + "']")
        end

    end


end