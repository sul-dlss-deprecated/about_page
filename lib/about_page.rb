require "about_page/engine"
require "about_page/configuration"
require "about_page/dependencies"
require "about_page/environment"
require "about_page/request_environment"

module AboutPage
  autoload :Fedora, "about_page/fedora"
  autoload :Solr, "about_page/solr"

  def self.configure
    yield(self.configuration)
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset!
    @configuration = nil
  end
end
