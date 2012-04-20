module AboutPage
  class AboutController < ApplicationController
    before_filter :only => :index do
      Configuration.request.environment = request.env if Configuration.request
    end

    def index
      @configuration = Configuration

      respond_to do |format|
        format.html # about_page.html.erb
        format.json { render :json => @configuration.to_json }
        format.xml  { render :xml  => @configuration.to_xml }
      end
    end
  end
end
