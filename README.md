# AboutPage

To use in a Hydra app:

    # In Gemfile
    gem 'about_page', :git => 'git://github.com/sul-dlss/about_page.git'

    # In config/initializers/about_page.rb
    AboutPage.configure do |config|
      config.app_name    = MyApplication.name                       # Application Name
      config.app_version = MyApplication::VERSION                   # Application Version
      config.fedora      = ActiveFedora::Base.connection_for_pid(0) # Rubydora::Repository instance
      config.solr        = ActiveFedora.solr                        # RSolr instance
    end
    
    # In config/routes.rb
    mount AboutPage::Engine => '/about(.:format)' # Or whever you want to access the about page
	
## Known Issues

* Solr must have LukeHandler enabled on /luke
* About page doesn't currently render in application layout