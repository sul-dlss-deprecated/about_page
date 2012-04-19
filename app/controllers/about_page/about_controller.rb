module AboutPage
  class AboutController < ApplicationController
    
    def section_for(key, value)
      if Configuration.environment_sections.nil?
        nil
      else
        Configuration.environment_sections.keys.find do |k| 
          key =~ Configuration.environment_sections[k]
        end
      end
    end
  
    def index
      @request_env = Hash.new { |h,k| h[k] = {} }
      [ENV,request.env].each do |environment|
        environment.each_pair do |key,value|
          section = section_for(key,value)
          unless section.nil?
            @request_env[section][key] = value if value.is_a? String
          end
        end
      end
    
      @dependencies = Bundler.load.specs.sort_by { |s| s.name }.collect do |spec|
        [spec.name,[spec.version,spec.git_version].join(" ")]
      end
      @dependencies.unshift([Configuration.app_name,Configuration.app_version])

      @solr_profile = Configuration.solr.nil? ? {} : Configuration.solr.luke(:show => 'schema', :numTerms => 0)['index']
      @fedora_profile = Configuration.fedora.nil? ? {} : Configuration.fedora.profile
      
      respond_to do |format|
        format.html # about_page.html.erb
        format.json { render :json => { :dependencies => @dependencies, :environment => @request_env, :solr => @solr_profile, :fedora => @fedora_profile } }
        format.xml  { render :xml  => { :dependencies => @dependencies, :environment => @request_env, :solr => @solr_profile, :fedora => @fedora_profile } }
      end
    end

  end
end
