module AboutPage
  class Fedora < AboutPage::Configuration::Node
    delegate :each_pair, :to_json, :to_xml, :to => :to_h

    attr_accessor :rubydora

    def initialize rubydora_instance
      self.rubydora = rubydora_instance
    end

    def to_h
      rubydora.profile
    end
  end
end
