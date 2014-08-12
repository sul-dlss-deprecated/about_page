require "about_page/engine"
require "about_page/configuration"
require "about_page/dependencies"
require "about_page/environment"
require "about_page/git_log"
require "about_page/request_environment"

module AboutPage
  autoload :Fedora, "about_page/fedora"
  autoload :Solr, "about_page/solr"

  def self.configuration_blocks
    @configuration_blocks ||= []
  end

  def self.configure &block
    self.configuration_blocks << block
  end

  def self.configuration
    @configuration ||= Configuration.new

    self.configuration_blocks.delete_if do |block|
      block.call(@configuration)
      true
    end

    @configuration
  end

  def self.reset!
    @configuration = nil
  end
end
