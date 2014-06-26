require 'ostruct'

module AboutPage

  class OpenStructWithHashAccess < OpenStruct
    delegate :each, :map, :to => :to_h
    def to_json(options = {})
      Hash[*@table.map { |k, v| [k, (v.to_h if v.respond_to? :to_h || v) ] }.flatten ]
    end

    def reject &block
      self.class.new to_h.reject(&block)
    end

    def select &block
      self.class.new to_h.select(&block)
    end

    def to_xml(options = {})
      @table
    end

    def to_h
      @table
    end
  end

  class Configuration
    attr_accessor :hash
    delegate :to_xml, :to_json, :to_yaml, :to => :to_h
    delegate :each, :map, :to => :to_h

    def initialize hash = nil
      @hash = hash || OpenStructWithHashAccess.new
    end

    def reject &block
      AboutPage::Configuration.new @hash.reject(&block)
    end

    def select &block
      AboutPage::Configuration.new @hash.select(&block)
    end

    def method_missing *args
      @hash.send(*args)
    end

    def preflight request
      self.nodes.each { |key, profile| profile.preflight(request) }
    end

    def valid?
       self.nodes.select { |key, profile| profile.respond_to? :ok? }.all? { |key, profile| profile.valid? }
    end

    def nodes
      self.hash.to_h.select { |key, profile| profile.is_a? AboutPage::Configuration::Node }
    end

    def set_headers! response
      self.nodes.each { |key, profile| profile.set_headers! response }
    end

    def to_h
      self.hash.to_h.inject({}) { |h,v| h[v[0]] = v[1].respond_to?(:to_h) ? v[1].to_h : v[1]; h }
    end

    def health_report
      self.nodes.collect do |key, profile| 
        if profile.class.validators.length > 0 
          health = profile.valid? ? 'ok' : 'error'
          errors = profile.errors.map {|a,m| "#{a} #{m}"}
          { 'component' => key.to_s, 'status' => health, 'errors' => errors }
        else
          nil
        end
      end.compact
    end

    class Node
      include ActiveModel::Validations
      delegate :each_pair, :to_xml, :to_json, :to_yaml, :to => :to_h

      class << self
        attr_reader :partial
        def render_with partial
          @partial = partial
        end
      end

      def preflight request
        errors.clear
        @request_expectations = request.params.select { |k,v| k =~ /^#{namespace}\./ }
      end

      def expects key 
        @request_expectations["#{namespace}.#{key}"] || self.options[:expects][key] if @request_expectations
      end

      def messages
        run_validations!
        errors.to_a.uniq
      end

      def to_h
        nil
      end

      def set_headers! response
        messages.each { |m| add_header(response, m) }
      end

      def add_header response, text
        response.headers['X-AboutPage-Warning'] ||= "" 
        response.headers['X-AboutPage-Warning'] += "#{self.class.name}: #{text};"
      end

      protected
      def namespace
        self.class.name.split("::").last.downcase
      end
    end
  end
end
