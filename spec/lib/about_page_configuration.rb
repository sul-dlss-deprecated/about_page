require 'spec_helper'

describe "AboutPage::Configuration" do
  it "" do
    AboutPage.configuration.environment.should be_a_kind_of AboutPage::Environment
  end

end
