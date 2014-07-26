require 'spec_helper'

feature 'searching from results page', :vcr do

  before { visit('/organizations') }

  context 'when search returns results' do
    before { search(keyword: 'maceo') }

    it 'displays the name of the agency as a link' do
      expect(page).to have_link('SanMaceo Example Agency')
    end

    it 'displays the name of the location as a link' do
      location_url = '/organizations/sanmaceo-example-agency/' \
                     'san-maceo-agency?button=&keyword=maceo&' \
                     'location=&org_name=&utf8=%E2%9C%93'
      expect(page).to have_link('San Maceo Agency', href: location_url)
    end

    it 'displays the location phone number' do
      expect(page).to have_content('(650) 372-6200')
    end

    it 'displays the location address' do
      expect(page).to have_content('2013 Avenue of the fellows')
    end

    it 'displays the location short description' do
      expect(page).to have_content('[NOTE THIS IS NOT A REAL ENTRY')
    end

    it 'displays the number of results' do
      expect(page).to have_content('Displaying 1 result')
    end

    it 'includes the results info in the page title' do
      expect(page).
        to have_title 'Search results for: maceo | Ohana Web Search'
    end

    it 'populates the keyword field with the search term' do
      expect(find_field('keyword').value).to eq('maceo')
    end
  end

  context 'when search returns no results' do
    before { search(location: '22031') }

    it 'displays a helpful error message' do
      expect(page).
        to have_content('Unfortunately, your search returned no results.')
    end

    it 'does not include the map canvas' do
      expect(page).not_to have_selector('#map-canvas')
    end

    it 'includes the .no-results selector' do
      expect(page).to have_selector('.no-results')
    end
  end

  it 'allows searching for a location' do
    search(location: '94403')
    expect(page).to have_content('San Mateo Free Medical Clinic')
  end

  it 'allows searching for an agency name' do
    search(org_name: 'samaritan')
    expect(page).to have_link('Samaritan House')
  end

  it 'allows searching for both keyword and location' do
    search(keyword: 'clinic', location: '94403')
    expect(page).to have_link('San Mateo Free Medical Clinic')
  end

  it 'allows searching for both keyword and agency name' do
    search(keyword: 'clinic', org_name: 'samaritan')
    expect(page).to have_link('San Mateo Free Medical Clinic')
  end

  it 'allows searching for both location and agency name' do
    search(location: '94403', org_name: 'samaritan')
    expect(page).to have_link('San Mateo Free Medical Clinic')
  end

  it 'allows searching for keyword, location, and agency name' do
    search(keyword: 'clinic', location: '94403', org_name: 'samaritan')
    expect(page).to have_link('San Mateo Free Medical Clinic')
  end

  context 'when clicking organization link in results' do
    it 'displays locations that belong to that organization' do
      search(keyword: 'Samaritan House')
      first('#list-view li').click_link('Samaritan House')
      expect(page).to have_link('Redwood City Free Medical Clinic')
    end
  end

  context 'when clicking the reset button' do
    xit 'clears out all the search input fields', :js do
      search(keyword: 'clinic', location: '94403', org_name: 'samaritan')
      find_by_id('reset-btn').click

      using_wait_time 5 do
        expect(find_field('keyword').value).to eq ''
        expect(find_field('location').value).to eq ''
        expect(find_field('org_name').value).to eq ''
      end

      find('#find-btn').click
      expect(page).to have_content('Fair Oaks Adult Activity Center')
    end
  end
end
