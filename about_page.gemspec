$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "about_page/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "about_page"
  s.version     = AboutPage::VERSION
  s.authors     = ["Michael B. Klein", "Chris Beer"]
  s.email       = ["mbklein@stanford.edu", "cabeer@stanford.edu"]
  s.homepage    = "http://github.com/sul-dlss/about_page"
  s.summary     = "Summary of AboutPage."
  s.description = "Description of AboutPage."

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")

  s.add_dependency "rails", ">= 3.2"
  s.add_dependency "grit"
  s.add_development_dependency "rspec", "~> 3.0"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "capybara"
  s.add_development_dependency "launchy"
  # s.add_dependency "jquery-rails"
end
