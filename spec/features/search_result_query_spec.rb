require 'rails_helper'

RSpec.describe "Search result list page", type: :feature do

  before do
    @building_abc = create :building, name: "Building ABC", name_de: "Gebäude ABC"
    @abc_building = create :building, name: "ABC Building", name_de: "ABC Gebäude"
    @building_xyz = create :building, name: "Building XYZ", name_de: "Gebäude XYZ"

    @room_abc = create :room, name: "Room ABC", name_de: "Raum ABC", room_type: "Pool room"
    @abc_room = create :room, name: "ABC Room", name_de: "ABC Raum", room_type: "Lecture hall"
    @room_xyz = create :room, name: "Room X.YZ", room_type: "Conference room"

    @bank = create :location, name: "Bank", name_de: "BankDE", details: "bank-details-abc",
                              details_de: "bank-details-abc-DE"

    @pavillon = create :location, name: "Pavillon", name_de: "PavillionDE",
                                  details: "pavillon-details-def", details_de: "pavillon-details-def-DE"

    @kocktail_bar = create :location,
                           name: "Kocktail Bar", name_de: "Kocktail Bar DE",
                           details: "kocktail bar-details-ghi", details_de: "kocktail bar-details-ghi-DE"

    @curie = create :person, first_name: "Marie", last_name: "Curie"
    @riemann = create :person, first_name: "Bernhard", last_name: "Riemann"
    @bernoulli = create :person, first_name: "Daniel", last_name: "Bernoulli"
  end

  it "shows buildings matching the query" do
    visit search_results_path(query: "xy")
    expect(page).to have_link(@building_xyz.name, href: building_path(@building_xyz, locale: I18n.locale), count: 1)

    visit search_results_path(query: "ABC")
    expect(page).to have_link(@building_abc.name, href: building_path(@building_abc, locale: I18n.locale), count: 1)
    expect(page).to have_link(@abc_building.name, href: building_path(@abc_building, locale: I18n.locale), count: 1)
  end

  it "does not show buildings not matching the query" do
    visit search_results_path(query: "xy")
    expect(page).not_to have_text(@building_abc.name)
    expect(page).not_to have_link(href: building_path(@building_abc, locale: I18n.locale))
    expect(page).not_to have_text(@abc_building.name)
    expect(page).not_to have_link(href: building_path(@abc_building, locale: I18n.locale))

    visit search_results_path(query: "ABC")
    expect(page).not_to have_text(@building_xyz.name)
    expect(page).not_to have_link(href: building_path(@building_xyz, locale: I18n.locale))
  end

  it "does show the right building when looking for the german name of the building" do
    visit search_results_path(query: "Gebäude ABC")
    expect(page).to have_link(@building_abc.name, href: building_path(@building_abc, locale: I18n.locale), count: 1)
  end

  it "lists buildings starting with the query before other found buildings" do
    visit search_results_path(query: "ABC")
    expect(page.body.index(@abc_building.name)).to be < page.body.index(@building_abc.name)

    visit search_results_path(query: "build")
    expect(page.body.index(@building_abc.name)).to be < page.body.index(@abc_building.name)
  end

  it "shows locations whose name matches the query" do
    visit search_results_path(query: "vill")
    expect(page).to have_link(@pavillon.name, href: location_path(@pavillon, locale: I18n.locale), count: 1)

    visit search_results_path(query: "Ban")
    expect(page).to have_link(@bank.name, href: location_path(@bank, locale: I18n.locale), count: 1)
  end

  it "shows locations whose details match the query" do
    visit search_results_path(query: "abc")
    expect(page).to have_link(@bank.name, href: location_path(@bank, locale: I18n.locale), count: 1)

    visit search_results_path(query: "def")
    expect(page).to have_link(@pavillon.name, href: location_path(@pavillon, locale: I18n.locale), count: 1)
  end

  it "does not show locations whose name and details do not match the query" do
    visit search_results_path(query: "Ban")
    expect(page).not_to have_text(@pavillon.name)
    expect(page).not_to have_link(href: location_path(@pavillon, locale: I18n.locale))
    expect(page).not_to have_text(@kocktail_bar.name)
    expect(page).not_to have_link(href: location_path(@kocktail_bar, locale: I18n.locale))

    visit search_results_path(query: "vill")
    expect(page).not_to have_text(@bank.name)
    expect(page).not_to have_link(href: location_path(@bank, locale: I18n.locale))

    visit search_results_path(query: "def")
    expect(page).not_to have_text(@bank.name)
    expect(page).not_to have_link(href: location_path(@bank, locale: I18n.locale))
    expect(page).not_to have_text(@kocktail_bar.name)
    expect(page).not_to have_link(href: location_path(@kocktail_bar, locale: I18n.locale))
  end

  it "shows locations when looking for the german details or name" do
    visit search_results_path(query: "BankDE")
    expect(page).to have_link(@bank.name, href: location_path(@bank, locale: I18n.locale), count: 1)

    visit search_results_path(query: "bank-details-abc-DE")
    expect(page).to have_link(@bank.name, href: location_path(@bank, locale: I18n.locale), count: 1)
  end

  it "lists locations starting with the query before other found locations" do
    visit search_results_path(query: "ba")
    expect(page.body.index(@bank.name)).to be < page.body.index(@kocktail_bar.name)

    visit search_results_path(query: "k")
    expect(page.body.index(@kocktail_bar.name)).to be < page.body.index(@bank.name)
  end

  it "shows rooms whose name matches the query" do
    visit search_results_path(query: "x.yz")
    expect(page).to have_link(@room_xyz.name, href: room_path(@room_xyz, locale: I18n.locale), count: 1)

    visit search_results_path(query: "AB")
    expect(page).to have_link(@room_abc.name, href: room_path(@room_abc, locale: I18n.locale), count: 1)
    expect(page).to have_link(@abc_room.name, href: room_path(@abc_room, locale: I18n.locale), count: 1)
  end

  it "shows the right room when looking for the german name" do
    visit search_results_path(query: "Raum ABC")
    expect(page).to have_link(@room_abc.name, href: room_path(@room_abc, locale: I18n.locale), count: 1)
  end

  it "shows rooms whose type matches the query" do
    visit search_results_path(query: "Lecture")
    expect(page).to have_link(@abc_room.name, href: room_path(@abc_room, locale: I18n.locale), count: 1)

    visit search_results_path(query: "room")
    expect(page).to have_link(@room_abc.name, href: room_path(@room_abc, locale: I18n.locale), count: 1)
    expect(page).to have_link(@room_xyz.name, href: room_path(@room_xyz, locale: I18n.locale), count: 1)
  end

  it "does not show rooms whose name and type does not match the query" do
    visit search_results_path(query: "x.yz")
    expect(page).not_to have_text(@room_abc.name)
    expect(page).not_to have_link(href: room_path(@room_abc, locale: I18n.locale))
    expect(page).not_to have_text(@abc_room.name)
    expect(page).not_to have_link(href: room_path(@abc_room, locale: I18n.locale))

    visit search_results_path(query: "AB")
    expect(page).not_to have_text(@room_xyz.name)
    expect(page).not_to have_link(href: room_path(@room_xyz, locale: I18n.locale))

    visit search_results_path(query: "hall")
    expect(page).not_to have_text(@room_abc.name)
    expect(page).not_to have_link(href: room_path(@room_abc, locale: I18n.locale))
    expect(page).not_to have_text(@room_xyz.name)
    expect(page).not_to have_link(href: room_path(@room_xyz, locale: I18n.locale))
  end

  it "shows people whose first name matches the query" do
    visit search_results_path(query: "marie")
    expect(page).to have_link(@curie.name, href: person_path(@curie, locale: I18n.locale), count: 1)

    visit search_results_path(query: "bern")
    expect(page).to have_link(@bernoulli.name, href: person_path(@bernoulli, locale: I18n.locale), count: 1)
  end

  it "shows people whose last name matches the query" do
    visit search_results_path(query: "CUrIe")
    expect(page).to have_link(@curie.name, href: person_path(@curie, locale: I18n.locale), count: 1)

    visit search_results_path(query: "bern")
    expect(page).to have_link(@riemann.name, href: person_path(@riemann, locale: I18n.locale), count: 1)
  end

  it "shows people whose full name matches the query" do
    visit search_results_path(query: "Daniel Bernoulli")
    expect(page).to have_link(@bernoulli.name, href: person_path(@bernoulli, locale: I18n.locale), count: 1)

    visit search_results_path(query: "ernhard Riem")
    expect(page).to have_link(@riemann.name, href: person_path(@riemann, locale: I18n.locale), count: 1)
  end

  it "does not show people whose first, last and full name do not match the query" do
    visit search_results_path(query: "marie")
    expect(page).not_to have_text(@bernoulli.name)
    expect(page).not_to have_link(href: person_path(@bernoulli, locale: I18n.locale))
    expect(page).not_to have_text(@riemann.name)
    expect(page).not_to have_link(href: person_path(@riemann, locale: I18n.locale))

    visit search_results_path(query: "bern")
    expect(page).not_to have_text(@curie.name)
    expect(page).not_to have_link(href: person_path(@curie, locale: I18n.locale))
  end

  it "ignores excessive spaces in the query" do
    visit search_results_path(query: "  Marie \t  \nCurie   ")
    expect(page).to have_link(@curie.name, href: person_path(@curie, locale: I18n.locale), count: 1)
  end

  it "accepts spaces instead of punctuation in query" do
    visit search_results_path(query: "x yz")
    expect(page).to have_link(@room_xyz.name, href: room_path(@room_xyz, locale: I18n.locale), count: 1)
  end

  it "displays a message if no results were found" do
    visit search_results_path(query: "nothing matches this")
    expect(page).to have_css('div#no_results_message')
  end

  it "does not find results if query consists only of spaces and punctuation" do
    visit search_results_path(query: "  \n. \t")
    expect(page).to have_css('div#no_results_message')
  end

  it "sorts results alphabetically by default" do
    visit search_results_path(query: "Building")
    expect(page).to have_css('img[src*="sort_alphabetically"]')
  end

  it "shows button to order by location" do
    visit search_results_path(query: "Building", sort_location: "true")
    expect(page).to have_css('img[src*="sort_location"]')
  end

  it "sort results correctly" do
    visit search_results_path(query: "Building", sort_location: "true")
    expect(page.body).to match(/ABC Building.*Building ABC.*Building XYZ/m)
  end

end
