require 'spec_helper'

feature 'nearby locations on details page', :js => true do

  context 'when API returns no nearby locations', :vcr do
    before(:each) { visit('/organizations/521d32c61974fcdb2b0002c2') }

    it "does not include nearby locations control" do
      within('#show-nearby-control') do
        expect(page).to have_content("NOTE: No nearby services at this location")
      end
    end

  end

  context 'when API returns nearby locations', :vcr do
    before(:each) { visit('/organizations/521d32b91974fcdb2b000002') }

    it "includes nearby locations control" do
      within('#show-nearby-control') do
        expect(page).to have_content("Show nearby services")
      end
    end

  end

end