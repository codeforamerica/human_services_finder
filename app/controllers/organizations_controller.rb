class OrganizationsController < ApplicationController
  before_filter :check_location_id, only: :show

  include ActionView::Helpers::TextHelper
  include ResultSummaryHelper

  TOP_LEVEL_CATEGORIES = %w(care education emergency food goods health housing
    legal money transit work).freeze

  # search results view
  def index

    # initialize query. Content may be blank if no results were found.
    @orgs = Organization.search(params)

    headers = Ohanakapa.last_response.headers

    @pages = Hash.new

    @pages[:total_count]   = headers["X-Total-Count"].to_i
    @pages[:current_count] = @orgs.blank? ? 0 : @orgs.count

    @pages[:total_pages]   = headers["X-Total-Pages"].to_i
    @pages[:current_page]  = headers["X-Current-Page"].to_i
    @pages[:prev_page]  = headers["X-Previous-Page"].to_i
    @pages[:next_page]  = headers["X-Next-Page"].to_i

    @pages[:prev_page] = nil if @pages[:prev_page] == 0
    @pages[:next_page] = nil if @pages[:next_page] == 0

    @pages[:pages] = []

    min = @pages[:current_page].to_i-2
    max = @pages[:current_page].to_i+2
    while min < 1
      min = min+1
      max = max+1
    end
    while max > @pages[:total_pages]
      min = min-1 if min > 1
      max = max-1
    end

    min.upto(max) do |n|
      @pages[:pages].push(n)
    end

    # The parameters to use to provide a link to the location
    @search_params = request.params.except(:action, :id, :_, :controller)
    @page_params = request.params.include?(:page) ? request.params.except(:page) : request.params

    ## Adds top-level category terms to @orgs for display on results list.
    ## This will likely be refactored to use the top-level keywords when those
    ## are organized in the database using OE or equivalent.
    # if @orgs.present?
    #   @orgs.each do |org|
    #     org.category = []
    #     if org.keywords.present?
    #       org.keywords.each do |k|
    #         org.category.push(k) if TOP_LEVEL_CATEGORIES.include? k.downcase
    #       end
    #     end
    #     org.category = org.category.uniq.sort
    #   end
    # end

    # initializes map data
    @map_data = generate_map_data(@orgs)

    # construct html and plain results summaries for use in display in the view (html)
    # and for display in the page title (plain)
    @map_search_summary_html = format_map_summary
    @search_summary_html = format_summary(params)
    @search_summary_plain = @search_summary_html.gsub('<strong>', '').gsub('</strong>', '')

    expires_in 30.minutes, :public => true
    if stale?(etag: @orgs, public: true)
      respond_to do |format|
        format.html # index.html.haml
      end
    end

  end

  # organization details view
  def show
    # retrieve specific organization's details
    @org = Organization.get(params[:id])

    # initializes map data
    @map_data = generate_map_data(Ohanakapa.nearby(params[:id],:radius=>0.5))

    # The parameters to use to provide a link back to search results
    @search_params = request.params.except(:action, :id, :_, :controller)
    # To disable or remove the Result list button on details page
    # when visiting location directly
    @referer = request.env['HTTP_REFERER']

    # respond to direct and ajax requests
    expires_in 30.minutes, :public => true
    if stale?(etag: @org, public: true)
      respond_to do |format|
        format.html #show.html.haml
      end
    end

  end

  private

  # Used for mapping nearby locations on details map view
  # generate json for the maps in the view
  # this will be injected into a <script> element in the view
  # and then consumed by the detail-map-manager javascript.
  # map_data parses the @org hash and retrieves all entries
  # that have coordinates, and returns that as json, otherwise map_data
  # ends up being nil and can be checked in the view with map_data.present?
  # @param data [Object] nearby API response
  # @return [Object] JSON object containing id, name, and coordinates.
  # Or nil if there are no nearby map entries.
  def generate_map_data(data)

    return nil if data.blank? # return immediately if data is empty

    @total_map_count = data.count # total number of returned results
    @current_map_count = 0

    coords_list = Hash.new(0) # used for tracking coordinate frequencies

    map_data = data.reduce([]) do |result, o|

      # hide "San Maceo" test case from results list (521d33a01974fcdb2b0026a9)
      #if o.name == "San Maceo Agency"
      #  data.delete(o)
      #else

      if o.key?(:coordinates)
        new_coords = o.coordinates

        # increment coordinate tracking and offset position if greater than 1 occurrance
        coords_list[new_coords.to_s] += 1
        offset = (0.0001*(coords_list[new_coords.to_s]-1))
        new_coords = [o.coordinates[0]-offset,o.coordinates[1]]

        details = {
          'id' => o.id,
          'name' => o.name,
          'coordinates' => new_coords
        }

        if o.organization.key?(:name) && o.organization.name != o.name
          details['agency'] = o.organization.name;
        end

        result << details
        @current_map_count = @current_map_count+1
      end

      result
    end

    # set a count and total value that will show how many (count)
    # of the data (total) were able to be located because they had coordinates.
    map_data.push({'count'=>@current_map_count,'total'=>@total_map_count})

    # set map_data to nil if there are no entries
    map_data = nil if (map_data[0]['count'] == 0)
    map_data = map_data.to_json.html_safe unless map_data.nil?
  end

  # from http://stackoverflow.com/questions/4810584/rails-3-how-to-render-a-partial-as-a-json-response
  # execute a block with a different format (ex: an html partial while in an ajax request)
  def with_format(format, &block)
    old_formats = formats
    self.formats = [format]
    block.call
    self.formats = old_formats
    nil
  end

  # If the location id is invalid, redirect to home page
  # and display an alert (TODO), or do something else.
  def check_location_id
    redirect_to root_path unless Organization.get(params[:id])
  end

end