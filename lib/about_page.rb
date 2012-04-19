require "about_page/engine"
require "about_page/configuration"

module AboutPage
  def self.configure
    yield(Configuration)
  end
end
