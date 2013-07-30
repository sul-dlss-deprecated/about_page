module AboutPage
  class Fedora < AboutPage::Configuration::Node
    delegate :each_pair, :to_json, :to_xml, :to => :to_h

    validates_each :profile do |record, attr, value| 
      unless value.present?
        record.errors.add attr, ": unable to connect to Fedora at #{record.rubydora.config[:url]}"
      end
    end

    render_with 'generic_hash'

    attr_accessor :rubydora

    def initialize rubydora_instance
      self.rubydora = rubydora_instance
    end

    def profile
      rubydora.profile || {}
    end

    def to_h
      profile
    end


    def preflight request
      # FIXME: ew.
      self.rubydora.instance_variable_set('@profile', nil)
      super(request)
    end

  end
end
