module AboutPage
  class Environment < AboutPage::Configuration::Node
    attr_accessor :sections

    def initialize(sections = {})
      self.sections = sections
    end

    def env
      ENV
    end

    def to_h
      @request_env ||= begin
         h = Hash.new { |h,k| h[k] = {} }

         env.each_pair do |key,value|
           section = section_for(key,value)
           unless section.nil?
             h[section][key] = value if value.is_a? String
           end
         end
         h
      end
    end

    def section_for(key, value)
      if sections.nil?
        nil
      else
        sections.keys.find do |k| 
          key =~ sections[k]
        end
      end
    end
  end
end
