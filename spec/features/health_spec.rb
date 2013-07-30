require 'spec_helper'

describe "the health page", :type => :request do
  before :all do
    module AboutPage
      class HealthTest < AboutPage::Configuration::Node
        attr_reader :healthy
        validates_each :healthy do |r,a,v|
          r.errors.add a, ": should be healthy" unless v
        end
        def initialize(state)
          @healthy = state
        end
      end
    end
  end

  after :all do
    AboutPage.send(:remove_const, :HealthTest)
  end

  describe "report" do
    before do
      AboutPage.reset!
      AboutPage.configure do |config|
        config.yup  = AboutPage::HealthTest.new(true)
        config.nope = AboutPage::HealthTest.new(false)
      end
    end

    describe "html" do
      before do
        visit('/about/health')
      end

      describe "healthy" do
        before do
          @context = page.find('li[class=component][1]')
        end

        it "should report the service name" do
          @context.should have_content('yup')
        end

        it "should contain an ok status" do
          @context.should have_xpath('span[@class="label label-success"][text() = "ok"]')
        end

        it "should not contain an error list" do
          @context.should_not have_xpath('ul/li[@class="component-error"]')
        end
      end

      describe "unhealthy" do
        before do
          @context = page.find('li[class=component][2]')
        end

        it "should report the service name" do
          @context.should have_content('nope')
        end

        it "should contain an error status" do
          @context.should have_xpath('span[@class="label label-important"][text() = "error"]')
        end

        it "should contain an error list" do
          @context.should have_xpath('ul/li[@class="component-error"]')
          @context.should have_content('Healthy : should be healthy')
        end
      end
    end
  end
end