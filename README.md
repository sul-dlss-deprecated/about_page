# AboutPage

[![Build Status](https://travis-ci.org/sul-dlss/about_page.svg?branch=master)](https://travis-ci.org/sul-dlss/about_page)

To use in a Hydra app:

    # In Gemfile
    gem 'about_page', :git => 'git://github.com/sul-dlss/about_page.git'

    # In config/initializers/about_page.rb
    AboutPage.configure do |config|
      config.app           = { :name => MyApplication.name, :version => MyApplication::VERSION }
      config.environment   = AboutPage::Environment.new({ 
        'Ruby' => /^(RUBY|GEM_|rvm)/    # This defines a "Ruby" subsection containing
                                        # environment variables whose names match the RegExp
      })
      config.request       = AboutPage::RequestEnvironment.new({
        'HTTP Server' => /^(SERVER_|POW_)/  # This defines an "HTTP Server" subsection containing
                                            # request variables whose names match the RegExp
      })
      config.dependencies  = AboutPage::Dependencies.new
      config.fedora        = AboutPage::Fedora.new(ActiveFedora::Base.connection_for_pid(0))  # Rubydora::Repository instance
      config.solr          = AboutPage::Solr.new(ActiveFedora.solr)                           # RSolr instance
    end
    
    # In config/routes.rb
    mount AboutPage::Engine => '/about(.:format)' # Or whever you want to access the about page

    # In app/assets/stylesheets/application.scss
    @import "about_page"
    
## Known Issues

* Solr must have LukeHandler enabled on /luke
