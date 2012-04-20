module AboutPage::Configuration
  def Environment sections = {}
    AboutPage::Configuration::Environment.new(sections)
  end

  class Environment
    attr_accessor :sections
    def initialize(sections = {})
      self.sections = sections

      self.sections.merge! {
        'Ruby' => /^(RUBY|GEM_|rvm)/,
        'HTTP Server' => /^(SERVER_|POW_)/,
        'WebAuth' => /^WEBAUTH_/
      }
    end

    def to_h
      @request_env = Hash.new { |h,k| h[k] = {} }
      [ENV,request.env].each do |environment|
        environment.each_pair do |key,value|
          section = section_for(key,value)
          unless section.nil?
            @request_env[section][key] = value if value.is_a? String
          end
        end
      end

      @request_env
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
