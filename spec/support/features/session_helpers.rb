module Features
  module SessionHelpers

    # search helpers
    def search(options = {})
      fill_in 'keyword', :with => options[:keyword]
      if options[:location].present?
        set_custom_value("location", "location", options[:location])
      end

      find('#find-btn').click
    end

    # Search from homepage.
    # @param options [Object] Hash containing keyword to search for.
    def search_from_home(options = {})
      visit ("/")
      keyword = options[:keyword]
      fill_in('keyword', :with => keyword)
      find('#find-btn').click
    end

    # Perform a search that returns 1 result
    def search_for_maceo
      visit('/organizations?keyword=maceo')
    end

    # Visit details page
    def visit_test_location
      visit('/organizations/sanmaceo-example-agency/san-maceo-agency')
    end

    # Perform search that returns 1 result that has no address
    def search_for_location_without_address
      visit('organizations?org_name=Location+with+no+phone')
    end

    # Visit details page that has no address
    def visit_location_with_no_address
      visit('organizations/location-with-no-phone')
    end

    # Perform a search that returns no results
    def search_for_no_results
      visit('/organizations?keyword=asdfdsggfdg')
    end

    # @param fieldset [String] the CSS name of the fieldset.
    # @param field [String] the CSS name of the field.
    # @param value [String] the checkbox to click.
    def select_existing_filter_option(fieldset, field, value)
      # Expand the filter
      find(:xpath, "//*[@id='#{fieldset}-options']/legend").click
      find('.toggle-group', text: value).trigger('mousedown')
    end

    # @param fieldset [String] the CSS name of the fieldset.
    # @param field [String] the CSS name of the field.
    # @param value [String] the value to fill the field with.
    def set_custom_value(fieldset, field, value)
      # Expand the filter
      find(:xpath, "//*[@id='#{fieldset}-toggle-group']/label").click
      # Click the '+' button to enable the input field
      find(:xpath, "//*[@id='#{fieldset}-toggle-group-1']/div/div/i").click
      fill_in("#{field}", with: value)
    end

    # navigation helpers
    def visit_details
      page.find("#list-view").first('a').click
    end

    def looks_like_results
      expect(page).to have_content("SanMaceo Example Agency")
      expect(page).to have_content("1 result")
      expect(page).to have_title "1 result"
    end

    def looks_like_no_results
      expect(page).to have_selector(".no-results")
      expect(page).to have_content("your search returned no results.")
      expect(page).not_to have_selector('#map-canvas')
    end

    def looks_like_location
      expect(find("#detail-info .description a")).to have_content("more")
      find("#detail-info .description a").click
      expect(find("#detail-info .description a")).to have_content("less")

      expect(page).to have_title "San Maceo Agency | SMC-Connect"

      expect(page).to have_content("Works to control")
      expect(page).to have_content("Profit and nonprofit")
      expect(page).to have_content("Marin County")
      expect(page).to have_content("Walk in")
      expect(page).to have_content("permits and photocopying")
      expect(page).to have_content("Russian")
      expect(page).to have_content("Special parking")
      expect(page).to have_link("Print")
      expect(page).to have_link("Directions")
    end

    def go_to_next_page
      first('.pagination').find_link('>').click
    end

    def go_to_prev_page
      first('.pagination').find_link('<').click
    end

    def go_to_page(page)
      first('.pagination').find_link(page).click
    end

    # helper to (hopefully) wait for page to load
    def delay
      sleep(2)
    end


  end
end