module AboutPage
  class Solr  < AboutPage::Configuration::Node
    delegate :each_pair, :to_json, :to_xml, :to => :to_h

    attr_accessor :rsolr, :options
    attr_writer :minimum_numdocs

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
    alias_method :to_h, :index

    def ok?
      true if index[:numDocs].to_i >= minimum_numdocs
    end

    def set_headers! response
      add_header(response, "solr numDocs: #{index[:numDocs]} < #{minimum_numdocs}") if index[:numDocs].to_i < minimum_numdocs
    end

    def preflight request
      self.minimum_numdocs = request.params['solr.numDocs'].to_i if request.params['solr.numDocs'].to_i
    end

    def minimum_numdocs
      @minimum_numdocs || self.options[:minimum_numdocs]
    end
  end
end
