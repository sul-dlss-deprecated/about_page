require 'spec_helper'

describe "the about page", :type => :request do
  describe "dependency versions" do
    before do
      visit("/about_page")
    end

    it "should contain a list of dependencies" do
      page.should have_content "about_page"
    end
  end

  describe "environment section" do
    before do
      visit("/about_page")
    end

    it "should contain a list of environment variables" do
      page.should have_content "GEM_HOME"
    end
  end
end
