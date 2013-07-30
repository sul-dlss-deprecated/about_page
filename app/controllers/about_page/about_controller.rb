module AboutPage
  class AboutController < ApplicationController
    before_filter :load_and_filter_configuration
    before_filter :only => :index do
      AboutPage.configuration.preflight(request)
    end

    def load_and_filter_configuration
      @configuration = AboutPage.configuration

      @configuration = @configuration.select { |key, value| (params[:filter].split(/[\W\+]/) + ["app"]).include? key.to_s } if params[:filter]
      @configuration.set_headers!(response)
    end

    def index
      respond_to do |format|
        format.html { render :status => @configuration.valid? ? 200 : 417 } # about_page.html.erb
        format.json { render :json   => @configuration.to_json }
        format.xml  { render :xml    => @configuration.to_xml  }
        format.yaml { render :text   => @configuration.to_yaml, :content_type => 'text/yaml' }
      end
    end

    def health
      @states = @configuration.health_report
      respond_to do |format|
        format.html { render }
        format.json { render :json => @states }
        format.xml  { render :xml  => @states }
        format.yaml { render :text => @states.to_yaml, :content_type => 'text/yaml' }
      end
    end
  end
end
