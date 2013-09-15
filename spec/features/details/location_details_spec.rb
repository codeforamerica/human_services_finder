require 'spec_helper'

feature "location details" do

  context "when the details page is visited via search results", :vcr, :js do
    it "includes address elements" do
      search_from_home(:keyword => 'maceo')
      visit_details
      expect(page).to have_content("Mailing Address")
      expect(page).to have_content("Physical Address")
      expect(page).to have_content("2013 Avenue of the fellows")
      expect(page).to have_content("90210")
      expect(page).to have_content("05201")
    end
  end

  context "when you return to the results page from details page", :vcr, :js do
    it 'displays the same search results' do
      search_from_home(:keyword => 'maceo')
      visit_details
      find_link("maceo@parker.com")
      find_link("a", :text=>"Back").click
      expect(page).to have_selector("#list-view")
      page.find(".agency").should have_link("SanMaceo Example Agency.")
    end
  end

  scenario "when the details page is visited directly", :vcr do
    visit('/organizations/521d33a01974fcdb2b0026a9')
    expect(page).to have_content("2013 Avenue of the fellows")
  end

  scenario "when the details page is visited directly with invalid id", :vcr do
    visit('/organizations/1234')
    expect(page).to have_content("CalFresh")
    expect(page).to have_title "SMC-Connect"
  end

  context 'when phone elements are present' do
    before(:each) do
      VCR.use_cassette('location_details/when_the_details_page_is_visited_directly') do
       visit('/organizations/521d33a01974fcdb2b0026a9')
      end
    end

    it "includes the Contact header" do
      expect(page).to have_content("Contact")
    end

    it "includes the department, type, and phone hours" do
      expect(page).to have_content("Information (650) 372-6200 TTY (Monday-Friday,
        8-5)")
    end

    it "includes the Fax number" do
      expect(page).to have_content("(650) 627-8244")
    end

    it "specifies TTY numbers" do
      expect(page).to have_content("(650) 372-6200 TTY")
    end

  end

  context 'when service elements are present' do
    before(:each) do
      VCR.use_cassette('location_details/when_the_details_page_is_visited_directly') do
       visit('/organizations/521d33a01974fcdb2b0026a9')
      end
    end

    it "includes eligibility info" do
      expect(page).to have_content("None")
    end

    it "includes audience info" do
      expect(page).to have_content("Profit and nonprofit businesses, the public, military facilities, schools and government entities")
    end

    it "includes fees info" do
      expect(page).to have_content("permits and photocopying")
    end

    it "includes hours info" do
      expect(page).to have_content("Monday-Friday, 8-5; Saturday, 10-6; Sunday 11-5")
    end

    it "includes how to apply info" do
      expect(page).to have_content("Walk in or apply by phone or mail")
    end

    # Wait time not included in the view.
    # Till we have a consistent meaning for wait time
    # it's best left out of the front-end view
    xit "includes wait info" do
      expect(page).to have_content("No wait to 2 weeks")
    end

    # Service areas not included in view.
    # Best to leave this out of the view, this is data that could easily be wrong and
    # it's better that the client contact the agency and ask for services and
    # be referred accordingly vs. going off this list.
    xit "includes service areas" do
      expect(page).to have_content("Marin County")
    end

    it "includes updated time" do
      # TODO The presence of the time causes this test to fail on Travis CI because
      # the time is checked against the Travis CI server time. The time has been
      # removed from the test till this can be sorted.
      #expect(page).to have_content("Monday, 9 September 2013 at 10:30 AM")
      expect(page).to have_content("Wednesday, 11 September 2013 at")
    end

  end

  context 'when location elements are present' do
    before(:each) do
      VCR.use_cassette('location_details/when_the_details_page_is_visited_directly') do
       visit('/organizations/521d33a01974fcdb2b0026a9')
      end
    end

    it "includes URLs" do
      expect(page).to have_link("www.smchealth.org")
    end

    it "includes accessibility info" do
      expect(page).to have_content("Disabled Parking")
    end

    it "includes ask for info" do
      expect(page).to have_content("Dawn of Midi")
    end

    it "doesn't display ask for as an array" do
      expect(page).to_not have_content("[James Brown, Dawn of Midi]")
    end

    # Contact is not included with view because we have an ask_for field already
    xit "includes Contact info" do
      expect(page).to have_content("Suzanne Badenhoop")
    end

    it "includes email info" do
      expect(page).to have_link("sanmaceo@co.sanmaceo.ca.us")
    end

    it "includes hours info" do
      expect(page).to have_content("Monday-Friday, 8-5; Saturday, 10-6; Sunday 11-5")
    end

    it "includes languages info" do
      expect(page).to have_content("Chinese (Cantonese)")
    end

    it "includes Mailing Address info" do
      expect(page).to have_content("Hella Fellas")
    end

    it "includes description" do
      expect(page).to have_content("Lorem ipsum")
    end

    it "includes short description" do
      within ".short-desc" do
        expect(page).to have_content("NOT A REAL ENTRY")
      end
    end

    it "includes transporation info" do
      expect(page).to have_content("SAMTRANS stops within 1 block")
    end

    it "sets the page title to the location name" do
      expect(page).to have_title("San Maceo Agency | SMC-Connect")
    end
  end

  context 'when farmers market with market match' do
    before(:each) do
      VCR.use_cassette('location_details/when_market_details_page_is_visited_directly') do
       visit('/organizations/522dee234becffff2700000e')
      end
    end

    it "includes Market Match" do
      expect(page).to have_content("Market Match")
    end

    it "includes payment info" do
      expect(page).to have_content("Payment methods accepted:")
    end

    it "includes info about payment types" do
      expect(page).to have_content("SNAP")
    end

    it "includes products info" do
      expect(page).to have_content("Products sold:")
      expect(page).to have_content("Baked Goods")
    end
  end
end
