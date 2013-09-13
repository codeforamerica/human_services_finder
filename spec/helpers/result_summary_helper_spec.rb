require 'spec_helper'
describe ResultSummaryHelper do

  describe "when current count < total_count" do

    before(:each) do
      @current_count = 1
      @total_count = 10
    end

    context 'when no keyword or location' do
      it 'shows result count only' do
        helper.format_summary({}).should eq("Displaying <strong>10 results</strong>")
      end
    end

    context 'when keyword but no location' do
      it 'shows result count and keyword' do
        helper.format_summary({:keyword => 'market' })
          .should eq("Displaying <strong>10 results</strong> matching <strong>'market'</strong>")
      end
    end

    context 'when location but no keyword' do
      it 'shows result count within 5 miles of location' do
        helper.format_summary({ :location => 'san mateo' })
          .should eq("Displaying <strong>10 results</strong> within <strong>5 miles of 'san mateo'</strong>")
      end
    end

    context 'with keyword and location' do
      it 'shows result count, keyword within 5 miles of location' do
        helper.format_summary({ :keyword => 'market', :location => 'san mateo'})
          .should eq("Displaying <strong>10 results</strong> matching <strong>'market'</strong> within <strong>5 miles of 'san mateo'</strong>")
      end
    end

    context 'with keyword, location and radius' do
      it 'shows result count and keyword within #{radius} miles of location' do
        helper.format_summary(
          { :keyword => 'market',
            :location => 'san mateo',
            :radius => 10
          })
          .should eq("Displaying <strong>10 results</strong> matching <strong>'market'</strong> within <strong>10 miles of 'san mateo'</strong>")
      end
    end
  end

  describe "when total_count = 1" do

    before(:each) do
      @current_count = 1
      @total_count = 1
    end

    context 'when no keyword or location' do
      it 'shows result count only' do
        helper.format_summary({}).should eq("Displaying <strong>1 result</strong>")
      end
    end

    context 'when keyword but no location' do
      it 'shows result count and keyword' do
        helper.format_summary({:keyword => 'market' })
          .should eq("Displaying <strong>1 result</strong> matching <strong>'market'</strong>")
      end
    end

    context 'when location but no keyword' do
      it 'shows result count within 5 miles of location' do
        helper.format_summary({ :location => 'san mateo' })
          .should eq("Displaying <strong>1 result</strong> within <strong>5 miles of 'san mateo'</strong>")
      end
    end

    context 'with keyword and location' do
      it 'shows result count, keyword within 5 miles of location' do
        helper.format_summary({ :keyword => 'market', :location => 'san mateo'})
          .should eq("Displaying <strong>1 result</strong> matching <strong>'market'</strong> within <strong>5 miles of 'san mateo'</strong>")
      end
    end

    context 'with keyword, location and radius' do
      it 'shows result count and keyword within #{radius} miles of location' do
        helper.format_summary(
          { :keyword => 'market',
            :location => 'san mateo',
            :radius => 10
          })
          .should eq("Displaying <strong>1 result</strong> matching <strong>'market'</strong> within <strong>10 miles of 'san mateo'</strong>")
      end
    end
  end

  describe "when total_count=0" do

    before(:each) do
      @current_count = 0
      @total_count = 0
    end

    context 'when no keyword or location' do
      it 'shows result count only' do
        helper.format_summary({}).should eq("Displaying <strong>0 results</strong>")
      end
    end

    context 'when keyword but no location' do
      it 'shows result count and keyword' do
        helper.format_summary({:keyword => 'market' })
          .should eq("Displaying <strong>0 results</strong> matching <strong>'market'</strong>")
      end
    end

    context 'when location but no keyword' do
      it 'shows result count within 5 miles of location' do
        helper.format_summary({ :location => 'san mateo' })
          .should eq("Displaying <strong>0 results</strong> within <strong>5 miles of 'san mateo'</strong>")
      end
    end

    context 'with keyword and location' do
      it 'shows result count, keyword within 5 miles of location' do
        helper.format_summary({ :keyword => 'market', :location => 'san mateo'})
          .should eq("Displaying <strong>0 results</strong> matching <strong>'market'</strong> within <strong>5 miles of 'san mateo'</strong>")
      end
    end

    context 'with keyword, location and radius' do
      it 'shows result count and keyword within #{radius} miles of location' do
        helper.format_summary(
          { :keyword => 'market',
            :location => 'san mateo',
            :radius => 10
          })
          .should eq("Displaying <strong>0 results</strong> matching <strong>'market'</strong> within <strong>10 miles of 'san mateo'</strong>")
      end
    end
  end
end