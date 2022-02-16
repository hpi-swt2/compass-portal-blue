require 'rails_helper'

RSpec.describe "Search result list page", type: :feature do

  before do
    @building_abc = create :building, name: "Building ABC"
    @abc_building = create :building, name: "ABC Building"
    @building_xyz = create :building, name: "Building XYZ"

    @room_abc = create :room, name: "Room ABC", room_type: "Pool room"
    @abc_room = create :room, name: "ABC Room", room_type: "Lecture hall"
    @room_xyz = create :room, name: "Room X.YZ", room_type: "Conference room"

    @bank = create :location, name: "Bank", details: "bank-details-abc"
    @pavillon = create :location, name: "Pavillon", details: "pavillon-details-def"
    @kocktail_bar = create :location, name: "Kocktail Bar", details: "kocktail bar-details-ghi"

    @curie = create :person, first_name: "Marie", last_name: "Curie"
    @riemann = create :person, first_name: "Bernhard", last_name: "Riemann"
    @bernoulli = create :person, first_name: "Daniel", last_name: "Bernoulli"

    @event_abc = create :event, name: "Event ABC", description: "This is a test event"
    @abc_event = create :event, name: "ABC event", description: "This some weird event thingy"
    @event_xyz = create :event, name: "Event XYZ", description: "This is another test event"
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

  it "shows rooms whose name matches the query" do
    visit search_results_path(query: "x.yz")
    expect(page).to have_link(@room_xyz.name, href: room_path(@room_xyz, locale: I18n.locale), count: 1)

    visit search_results_path(query: "AB")
    expect(page).to have_link(@room_abc.name, href: room_path(@room_abc, locale: I18n.locale), count: 1)
    expect(page).to have_link(@abc_room.name, href: room_path(@abc_room, locale: I18n.locale), count: 1)
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

  it "shows events whose name matches the query" do
    visit search_results_path(query: "xyz")
    expect(page).to have_link(@event_xyz.name, href: event_path(@event_xyz, locale: I18n.locale), count: 1)

    visit search_results_path(query: "AB")
    expect(page).to have_link(@event_abc.name, href: event_path(@event_abc, locale: I18n.locale), count: 1)
    expect(page).to have_link(@abc_event.name, href: event_path(@abc_event, locale: I18n.locale), count: 1)
  end

  it "shows events whose description matches the query" do
    visit search_results_path(query: "thingy")
    expect(page).to have_link(@abc_event.name, href: event_path(@abc_event, locale: I18n.locale), count: 1)

    visit search_results_path(query: "test")
    expect(page).to have_link(@event_abc.name, href: event_path(@event_abc, locale: I18n.locale), count: 1)
    expect(page).to have_link(@event_xyz.name, href: event_path(@event_xyz, locale: I18n.locale), count: 1)
  end

  it "does not show events whose name and type does not match the query" do
    visit search_results_path(query: "xyz")
    expect(page).not_to have_text(@event_abc.name)
    expect(page).not_to have_link(href: event_path(@event_abc, locale: I18n.locale))
    expect(page).not_to have_text(@abc_event.name)
    expect(page).not_to have_link(href: event_path(@abc_event, locale: I18n.locale))

    visit search_results_path(query: "AB")
    expect(page).not_to have_text(@event_xyz.name)
    expect(page).not_to have_link(href: event_path(@event_xyz, locale: I18n.locale))

    visit search_results_path(query: "weird")
    expect(page).not_to have_text(@event_abc.name)
    expect(page).not_to have_link(href: event_path(@event_abc, locale: I18n.locale))
    expect(page).not_to have_text(@event_xyz.name)
    expect(page).not_to have_link(href: event_path(@event_xyz, locale: I18n.locale))
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
