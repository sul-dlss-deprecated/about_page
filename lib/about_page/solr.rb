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

    def registry
      @registry ||= begin
                      h = {}
                      resp = rsolr.get 'admin/registry.jsp', :params => { :wt => 'xml' }
                      doc = Nokogiri::XML resp

                      doc.xpath('/solr/*').each do |node|
                        next if node.name == "solr-info"
                        h[node.name] = node.text
                      end

                      h
                    end
    rescue
      {}
    end

    def index
      schema['index'] || {}
    end

    def to_h
      index.merge(registry)
    end

    def ok?
      return false if schema.empty?
      return false if index[:numDocs].to_i < minimum_numdocs

      true
    end

    def messages
      a = []
      a << "Unable to connect to solr: #{self.rsolr.inspect}" if schema.empty?
      a << "Solr numDocs (#{index[:numDocs]}) is less than the minimum #{minimum_numdocs}" if !schema.empty? and index[:numDocs].to_i < minimum_numdocs

      a
    end

    def preflight request
      @schema = nil
      @minimum_numdocs = request.params['solr.numDocs'].to_i if request.params['solr.numDocs'].to_i
    end

    def minimum_numdocs
      @minimum_numdocs || self.options[:minimum_numdocs]
    end
  end
end
