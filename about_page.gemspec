$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "about_page/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "about_page"
  s.version     = AboutPage::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of AboutPage."
  s.description = "TODO: Description of AboutPage."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "capybara"
  s.add_development_dependency "launchy"
  # s.add_dependency "jquery-rails"
end
