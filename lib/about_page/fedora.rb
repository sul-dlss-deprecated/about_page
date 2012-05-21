module AboutPage
  class Fedora < AboutPage::Configuration::Node
    delegate :each_pair, :to_json, :to_xml, :to => :to_h

    attr_accessor :rubydora

    def initialize rubydora_instance
      self.rubydora = rubydora_instance
    end

    def to_h
      rubydora.profile || {}
    end

    def ok?
      !to_h.empty?
    end

    def messages
      a = []
      a << "Unable to connect to fedora: #{self.rubydora.inspect}" if rubydora.profile.nil?

      a
    end

    def preflight request
      # FIXME: ew.
      self.rubydora.instance_variable_set('@profile', nil)
    end

  end
end
