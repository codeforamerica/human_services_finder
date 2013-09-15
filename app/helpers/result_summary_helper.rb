module ResultSummaryHelper
  extend ActionView::Helpers::TextHelper

  # Formats search result summary text
  # @param params [Hash] Contains last request params
  # @return [String] Result summary string for display on search results view.
  def format_summary(params)

    keyword, location, radius =
      params[:keyword],
      params[:location],
      params[:radius]

    #set radius default
    radius = 5 if radius.blank?

    summary = ""
    per_page = 30

    if @pages[:total_count] == 0
      summary << "No results"
    elsif @pages[:total_count] < per_page
      summary << "Displaying <strong>"
      summary << self.pluralize(@pages[:total_count], 'result')
      summary << "</strong>"
    else
      page_range_end = (@pages[:current_page]*per_page)
      page_range_start = page_range_end-per_page+1
      page_range_end = @pages[:total_count] if page_range_end > @pages[:total_count]

      summary << "Displaying <strong>#{page_range_start}-#{page_range_end}</strong> of "
      summary << self.pluralize(@pages[:total_count], 'result')
    end

    summary << " matching <strong>'#{keyword}'</strong>" if keyword.present?

    if location.present?
      summary << " within <strong>#{self.pluralize(radius, 'mile')} of '#{location}'</strong>"
    end

    summary.html_safe
  end

  # Formats map result summary text
  # @return [String] Result summary string for display on search results view.
  def format_map_summary
    if @current_map_count == @total_map_count
      summary = ""
    else
      summary = " • <em>#{@current_map_count} of #{@total_map_count} located on map</em>"
    end
    summary.html_safe
  end

end