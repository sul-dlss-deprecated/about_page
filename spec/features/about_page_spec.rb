require 'spec_helper'

describe "the about page", :type => :request do
  before :all do
    AboutPage.reset!

AboutPage.configure do |config|
  config.app = { :name => 'Application Name', :version => '0.0.0' }

  config.dependencies = AboutPage::Dependencies.new

  config.environment = AboutPage::Environment.new({ 
    'Ruby' => /^(RUBY|GEM_|rvm)/
  })

  config.request = AboutPage::RequestEnvironment.new({
    'HTTP Server' => /^(SERVER_|POW_)/,
    'WebAuth' => /^WEBAUTH_/
  })
end
  end
  describe "dependency versions" do
    before do
      visit("/about")
    end

    it "should contain a list of dependencies" do
      page.should have_content "about_page"
    end
  end

  describe "environment section" do
    before do
      visit("/about")
    end

    it "should contain a list of environment variables" do
      page.should have_content "GEM_HOME"
    end
  end

  describe "xml" do
    before do
      visit("/about.xml")
    end
    
    it "should" do
      page.body.should_not be_empty
    end
  end

  describe "json" do
    before do
      visit("/about.json")
    end
    
    it "should" do
      page.body.should_not be_empty
    end
  end
end
