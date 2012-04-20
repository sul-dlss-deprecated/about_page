module AboutPage
  class Environment
    attr_accessor :sections
    delegate :each_pair, :to_json, :to_xml, :to => :to_h

    def initialize(sections = {})
      self.sections = sections
    end

    def to_h
      @request_env ||= begin
         h = Hash.new { |h,k| h[k] = {} }

         environment.each_pair do |key,value|
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

    def environment
      ENV
    end
  end
end
