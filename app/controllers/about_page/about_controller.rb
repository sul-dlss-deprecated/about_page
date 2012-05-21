module AboutPage
  class AboutController < ApplicationController
    before_filter :only => :index do
      AboutPage.configuration.preflight(request)
    end

    def index
      @configuration = AboutPage.configuration

      @configuration = @configuration.select { |key, value| (params[:filter].split(/[\W\+]/) + ["app"]).include? key.to_s } if params[:filter]
      @configuration.set_headers!(response)

      respond_to do |format|
        format.html { render :status => @configuration.ok? ? 200 : 417 } # about_page.html.erb
        format.json { render :json => @configuration.to_json }
        format.xml  { render :xml  => @configuration.to_xml }
      end
    end
  end
end
