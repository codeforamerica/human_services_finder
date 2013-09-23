require 'spec_helper'

feature "homepage search" do

  scenario 'with keyword that returns results', :vcr do
    search_from_home(:keyword => 'maceo')
    looks_like_results
    find_field("keyword").value.should == "maceo"
    expect(page).to_not have_content("1 result located!")
  end

  scenario 'with keyword that returns no results', :vcr do
    search_from_home(:keyword => 'asdfg')
    looks_like_no_results
    expect(page).to_not have_content("No results located!")
  end

    scenario "when searching for 'food stamps'", :vcr do
    search_from_home(:keyword => 'food stamps')
    expect(page).to have_content("Known federally as SNAP")
  end

  scenario "when searching for 'health care reform'", :vcr do
    search_from_home(:keyword => 'Health care reform')
    expect(page).to have_content("Millions of Californians can choose")
  end

  scenario "when searching for 'market match'", :vcr do
    search_from_home(:keyword => 'market match')
    expect(page).to have_content("an extra $5 when they spend at least $10")
  end

  scenario "when searching for 'sfmnp'", :vcr do
    search_from_home(:keyword => 'SFMNP')
    expect(page).to have_content("provides low-income seniors with coupons")
  end

  scenario "when searching for 'wic'", :vcr do
    search_from_home(:keyword => 'wic')
    expect(page).to have_content("provides assistance for low-income")
  end

  scenario "when clicking a category", :vcr do
    visit("/")
    click_link("Health Insurance")
    expect(page).to have_content("A project of the Tides Center")
  end

  xscenario "when result has keyword matching top-level category", :vcr do
    visit("/")
    click_link("Market Match")
    expect(page).to have_link("Food")
  end

  # location is no longer displayed on homepage. Leaving this in case it's re-added.
  xscenario 'with location that returns results', :vcr do
    search_from_home(:location => '94060')
    looks_like_puente
    find_field("location").value.should == "94060"
    expect(page).to_not have_content("1 result located!")
  end

  xscenario 'with location that returns no results', :vcr do
    search_from_home(:location => 'asdfg')
    looks_like_no_results
    expect(page).to_not have_content("No results located!")
  end

  xscenario 'with keyword and location that returns results', :vcr do
    search_from_home(:keyword => "puente", :location => '94060')
    looks_like_puente
    find_field("location").value.should == "94060"
    expect(page).to_not have_content("1 result located!")
  end

  xscenario 'with keyword and location that returns no results', :vcr do
    search_from_home(:keyword => "sdaff", :location => '94403')
    looks_like_no_results
    expect(page).to_not have_content("No results located!")
  end

  scenario "when click Kind link", :vcr do
    search_from_home(:keyword => 'soccer')
    page.first("a", text: "Other").click
    expect(page).to_not have_content("Sports")
    expect(page).to have_content("415 results")
  end

end