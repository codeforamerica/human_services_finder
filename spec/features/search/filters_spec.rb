require 'spec_helper'

feature "results page search", :js, :vcr do

  background do
    page.set_rack_session('aggregate_locations' => [])
    page.set_rack_session('aggregate_org_names' => [])
    search_from_home(:keyword=>"asdfg")
  end

  # test filter fieldset legend toggling across all filters
  scenario 'when location filter has no cached values and legend is toggled' do
    test_filter_legend("location")
  end

  scenario 'when service-area filter has no cached values and legend is toggled' do
    test_filter_legend("service-area", "San Mateo County, CA")
  end

  scenario 'when kind filter has no cached values and legend is toggled' do
    test_filter_legend("kind", "Human Services",13)
  end

  scenario 'when agency filter has no cached values and legend is toggled' do
    test_filter_legend("org-name")
  end

  # test filter fieldset toggle toggling across all filters
  scenario 'when location filter has no cached values and toggle is toggled' do
    within("#location-options") do
      # Click on the "All" checkbox
      all(".current-option label").last.click
      # Click on the "All" checkbox again
      find(".options label",:text => "All").click
      expect(all(".current-option label").last).to have_content("All")
    end
  end

  scenario 'when service-area filter has no cached values and toggle is toggled' do
    within("#service-area-options") do
      # Click on the "All" checkbox
      all(".current-option label").last.click
      # Click on the "All" checkbox again
      find(".options label",:text => "San Mateo County, CA").click
      expect(all(".current-option label").last).to have_content("San Mateo County, CA")
    end
  end

  scenario 'when kind filter has no cached values and toggle is toggled' do
    within("#kind-options") do
      # Click on the "All" checkbox
      all(".current-option label").last.click
      # Click on the "All" checkbox again
      find(".options label",:text => "Human Services").click
      expect(all(".current-option label").last).to have_content("Human Services")
    end
  end

  scenario 'when agency filter has no cached values and toggle is toggled' do
    within("#org-name-options") do
      # Click on the "All" checkbox
      all(".current-option label").last.click
      # Click on the "All" checkbox again
      find(".options label",:text => "All").click
      expect(all(".current-option label").last).to have_content("All")
    end
  end

  # test adding custom value to filters that accept custom values
  scenario 'when location filter has no cached values and custom value is added' do
    fill_in('keyword', with: '')
    set_filter("location", "location", "94403")
    all(".toggle-group-wrapper.add label").first.trigger("mousedown")
    expect(page).to have_content("41 results within 5 miles of '94403'")
  end

  scenario 'when agency filter has no cached values and custom value is added' do
    fill_in('keyword', with: '')
    set_filter("org-name", "org_name", "Salvation Army")
    all(".toggle-group-wrapper.add label").first.trigger("mousedown")
    expect(page).to have_content("3 results")
  end

  # test adding custom value to filters and retrieving no results
  scenario 'when location filter has custom value and no results' do
    set_filter("location", "location", "San Mateo, CA")
    find('#find-btn').click

    within("#location-options") do
      find(".closed").trigger('mousedown')
      expect(find(".available-options")).to have_css(".toggle-group", :count => 2)
      expect(find_by_id("location-option-input").value).to eq "San Mateo, CA"
    end
  end

  scenario 'when agency filter has custom value and no results' do
    set_filter("org-name", "org_name", "United States Government")
    find('#find-btn').click

    within("#org-name-options") do
      find(".closed").trigger('mousedown')
      expect(find(".available-options")).to have_css(".toggle-group", :count => 2)
      expect(find_by_id("org-name-option-input").value).to eq "United States Government"
    end
  end

  # test adding custom value to filters and retrieving results
  scenario 'when location filter has custom value and has results' do
    set_filter("location", "location", "San Mateo, CA")
    fill_in('keyword', :with => '')
    find('#find-btn').click

    within("#location-options") do
      find(".closed").click
      expect(find(".available-options")).to have_css(".toggle-group", :count=>3)
      expect(page).not_to have_css("location")
    end
  end

  scenario 'when agency filter has custom value and has results' do
    set_filter("org-name", "org_name", "Salvation Army")
    fill_in('keyword', :with => '')
    find('#find-btn').click

    within("#org-name-options") do
      find(".closed").click
      expect(find(".available-options")).to have_css(".toggle-group", :count=>3)
      expect(page).not_to have_css("org_name")
    end
  end

  # test filter selection across all filters
  scenario 'when location filter has cached values and new option is selected' do
    fill_in('keyword', :with => "")
    find('#find-btn').click
    set_filter("location", "location", "Redwood City, CA", false)
    find('#find-btn').click
    expect(page).to have_content("54 results within 5 miles of 'Redwood City, CA'")
    expect(all("#location-options .current-option label").last).to have_content("Redwood City, CA")
  end

  scenario 'when service-area filter has cached values and new option is selected', :vcr do
    fill_in('keyword', :with => '') # clear keyword
    set_filter("service-area", "service_area", "All", false)
    find('#find-btn').click
    expect(page).to have_content("130 results")
    expect(all("#service-area-options .current-option label").last).to have_content("All")
  end

  scenario 'when kind filter has cached values and new option is selected', :vcr do
    fill_in('keyword', :with => '') # clear keyword
    set_filter("kind", "kind", "Other", false)
    find('#find-btn').click
    expect(page).to have_content("35 results")
    expect(all("#kind-options .current-option label").last).to have_content("Other")
  end

  scenario 'when agency filter has cached values and new option is selected' do
    fill_in('keyword', :with => '')
    find('#find-btn').click
    visit("/organizations?page=3")
    set_filter("org-name", "org_name", "San Mateo County Human Services Agency", false)
    find('#find-btn').click
    expect(page).to have_content("13 results")
    expect(all("#org-name-options .current-option label").last).to have_content("San Mateo County Human Services Agency")
  end

  # user clicks filter links in results list
  scenario 'when clicking organization link in results' do
    search(:keyword => "Samaritan House")
    first("#list-view li").click_link("Samaritan House")
    expect(page).to have_content("Redwood City Free Medical Clinic")

    # check filter settings
    expect(all("#location-options .current-option label").last).to have_content("All")
    expect(all("#service-area-options .current-option label").last).to have_content("All")
    expect(all("#kind-options .current-option label").last).to have_content("All")
    expect(all("#org-name-options .current-option label").last).to have_content("Samaritan House")
  end

  scenario 'when clicking the reset button' do
    expect(page).to have_content("No results")
    find_by_id("reset-btn").click

    # check filter settings
    expect(find_field("keyword").value).to eq ""
    expect(all("#location-options .current-option label").last).to have_content("All")
    expect(all("#service-area-options .current-option label").last).to have_content("All")
    expect(all("#kind-options .current-option label").last).to have_content("All")
    expect(all("#org-name-options .current-option label").last).to have_content("All")

    find('#find-btn').click
    expect(page).to have_content("339 results")
  end
end
