module AboutPage
  class Solr  < AboutPage::Configuration::Node
    delegate :each_pair, :to_json, :to_xml, :to => :to_h

    attr_accessor :rsolr, :options

    def initialize rsolr_instance, options = {}
      self.rsolr = rsolr_instance
      self.options = options

      self.options[:minimum_numdocs] ||= 1
    end

    def schema
      @schema ||= rsolr.luke(:show => 'schema', :numTerms => 0)
    rescue
      {}
    end

    def index
      schema['index'] || {}
    end

    def to_h
      index
    end

    def ok?
      true if index[:numDocs].to_i >= self.options[:minimum_numdocs]
    rescue
      false
    end

    def set_headers! response
      add_header(response, "solr numDocs: #{index[:numDocs]} < #{self.options[:minimum_numdocs]}") if index[:numDocs].to_i < self.options[:minimum_numdocs]
    end

    def preflight request
      self.options[:minimum_numdocs] = request.params['solr.numDocs'].to_i if request.params['solr.numDocs'].to_i
    end
  end
end
