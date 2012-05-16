require 'rails/generators'

class AboutPageGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  def generate_config
    copy_file("about_page.rb", "config/initializers/about_page.rb")
  end

  def add_routes
    route "mount AboutPage::Engine => '/about(.:format)'"
  end
end
