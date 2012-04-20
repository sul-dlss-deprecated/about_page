require "about_page/engine"
require "about_page/dependencies"
require "about_page/environment"
require "about_page/request_environment"
require "about_page/configuration"

module AboutPage
  def self.configure
    yield(Configuration)
  end
end
