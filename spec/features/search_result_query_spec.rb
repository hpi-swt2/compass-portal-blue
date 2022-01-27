require 'rails_helper'

RSpec.describe "Search result list page", type: :feature do

  before do
    @building_abc = create :building, name: "Building ABC"
    @abc_building = create :building, name: "ABC Building"
    @building_xyz = create :building, name: "Building XYZ"

    @room_abc = create :room, name: "Room ABC"
    @abc_room = create :room, name: "ABC Room"
    @room_xyz = create :room, name: "Room X.YZ"

    @bank = create :location, name: "Bank", details: "bank-details"
    @pavillon = create :location, name: "Pavillon", details: "pavillon-details"
    @kocktail_bar = create :location, name: "Kocktail Bar", details: "kocktail bar-details"

    @curie = create :person, first_name: "Marie", last_name: "Curie"
    @riemann = create :person, first_name: "Bernhard", last_name: "Riemann"
    @bernoulli = create :person, first_name: "Daniel", last_name: "Bernoulli"
  end

  it "shows buildings matching the query" do
    visit search_results_path(query: "xy")
    expect(page).to have_link(@building_xyz.name, href: building_path(@building_xyz), count: 1)

    visit search_results_path(query: "ABC")
    expect(page).to have_link(@building_abc.name, href: building_path(@building_abc), count: 1)
    expect(page).to have_link(@abc_building.name, href: building_path(@abc_building), count: 1)
  end

  it "does not show buildings not matching the query" do
    visit search_results_path(query: "xy")
    expect(page).not_to have_text(@building_abc.name)
    expect(page).not_to have_link(href: building_path(@building_abc))
    expect(page).not_to have_text(@abc_building.name)
    expect(page).not_to have_link(href: building_path(@abc_building))

    visit search_results_path(query: "ABC")
    expect(page).not_to have_text(@building_xyz.name)
    expect(page).not_to have_link(href: building_path(@building_xyz))
  end

  it "lists buildings starting with the query before other found buildings" do
    visit search_results_path(query: "ABC")
    expect(page.body.index(@abc_building.name)).to be < page.body.index(@building_abc.name)

    visit search_results_path(query: "build")
    expect(page.body.index(@building_abc.name)).to be < page.body.index(@abc_building.name)
  end

  it "shows locations matching the query" do
    visit search_results_path(query: "vill")
    expect(page).to have_link(@pavillon.name, href: location_path(@pavillon), count: 1)

    visit search_results_path(query: "Ban")
    expect(page).to have_link(@bank.name, href: location_path(@bank), count: 1)
  end

  it "does not show locations not matching the query" do
    visit search_results_path(query: "Ban")
    expect(page).not_to have_text(@pavillon.name)
    expect(page).not_to have_link(href: location_path(@pavillon))
    expect(page).not_to have_text(@kocktail_bar.name)
    expect(page).not_to have_link(href: location_path(@kocktail_bar))

    visit search_results_path(query: "vill")
    expect(page).not_to have_text(@bank.name)
    expect(page).not_to have_link(href: location_path(@bank))
  end

  it "lists locations starting with the query before other found locations" do
    visit search_results_path(query: "ba")
    expect(page.body.index(@bank.name)).to be < page.body.index(@kocktail_bar.name)

    visit search_results_path(query: "k")
    expect(page.body.index(@kocktail_bar.name)).to be < page.body.index(@bank.name)
  end

  it "shows rooms matching the query" do
    visit search_results_path(query: "x.yz")
    expect(page).to have_link(@room_xyz.name, href: room_path(@room_xyz), count: 1)

    visit search_results_path(query: "AB")
    expect(page).to have_link(@room_abc.name, href: room_path(@room_abc), count: 1)
    expect(page).to have_link(@abc_room.name, href: room_path(@abc_room), count: 1)
  end

  it "does not show rooms not matching the query" do
    visit search_results_path(query: "x.yz")
    expect(page).not_to have_text(@room_abc.name)
    expect(page).not_to have_link(href: room_path(@room_abc))
    expect(page).not_to have_text(@abc_room.name)
    expect(page).not_to have_link(href: room_path(@abc_room))

    visit search_results_path(query: "AB")
    expect(page).not_to have_text(@room_xyz.name)
    expect(page).not_to have_link(href: room_path(@room_xyz))
  end

  it "lists rooms starting with the query before other found rooms" do
    visit search_results_path(query: "ABC")
    expect(page.body.index(@abc_room.name)).to be < page.body.index(@room_abc.name)

    visit search_results_path(query: "room")
    expect(page.body.index(@room_abc.name)).to be < page.body.index(@abc_room.name)
  end

  it "shows people whose first name matches the query" do
    visit search_results_path(query: "marie")
    expect(page).to have_link(@curie.name, href: person_path(@curie), count: 1)

    visit search_results_path(query: "bern")
    expect(page).to have_link(@bernoulli.name, href: person_path(@bernoulli), count: 1)
  end

  it "shows people whose last name matches the query" do
    visit search_results_path(query: "CUrIe")
    expect(page).to have_link(@curie.name, href: person_path(@curie), count: 1)

    visit search_results_path(query: "bern")
    expect(page).to have_link(@riemann.name, href: person_path(@riemann), count: 1)
  end

  it "shows people whose full name matches the query" do
    visit search_results_path(query: "Daniel Bernoulli")
    expect(page).to have_link(@bernoulli.name, href: person_path(@bernoulli), count: 1)

    visit search_results_path(query: "ernhard Riem")
    expect(page).to have_link(@riemann.name, href: person_path(@riemann), count: 1)
  end

  it "does not show people whose first, last and full name do not match the query" do
    visit search_results_path(query: "marie")
    expect(page).not_to have_text(@bernoulli.name)
    expect(page).not_to have_link(href: person_path(@bernoulli))
    expect(page).not_to have_text(@riemann.name)
    expect(page).not_to have_link(href: person_path(@riemann))

    visit search_results_path(query: "bern")
    expect(page).not_to have_text(@curie.name)
    expect(page).not_to have_link(href: person_path(@curie))
  end

  it "lists people whose full name or last name starts with the query before other found people" do
    visit search_results_path(query: "rie")
    expect(page.body.index(@riemann.name)).to be < page.body.index(@curie.name)

    visit search_results_path(query: "ma")
    expect(page.body.index(@curie.name)).to be < page.body.index(@riemann.name)
  end

  it "ignores excessive spaces in the query" do
    visit search_results_path(query: "  Marie \t  \nCurie   ")
    expect(page).to have_link(@curie.name, href: person_path(@curie), count: 1)
  end

  it "accepts spaces instead of punctuation in query" do
    visit search_results_path(query: "x yz")
    expect(page).to have_link(@room_xyz.name, href: room_path(@room_xyz), count: 1)
  end

  it "displays a message if no results were found" do
    visit search_results_path(query: "nothing matches this")
    expect(page).to have_css('div#no_results_message')
  end

  it "does not find results if query consists only of spaces and punctuation" do
    visit search_results_path(query: "  \n. \t")
    expect(page).to have_css('div#no_results_message')
  end
end
