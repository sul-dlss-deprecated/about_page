module AboutPage
  class Solr  < AboutPage::Configuration::Node
    delegate :each_pair, :to_json, :to_xml, :to => :to_h
    
    attr_accessor :rsolr, :options

    validates_each :ping do |record, attr, value|
      unless value == 'OK'
        record.errors.add attr, ": unable to ping Solr at #{record.rsolr.uri.to_s}"
      end
    end
    validates :numDocs, :numericality => { :greater_than_or_equal_to => Proc.new { |c| c.expects(:numDocs) } }

    render_with 'generic_hash'

    def initialize rsolr_instance, options = {}
      self.rsolr = rsolr_instance
      self.options = options
      self.options[:luke]     ||= 'admin/luke'
      if self.options[:registry] == :registry
        self.options[:registry] = 'admin/registry.jsp'
      else
        self.options[:registry] ||= 'admin/mbeans'
      end
      self.options[:expects]  ||= {}
      self.options[:expects][:numDocs] ||= 1

      @request_expectations = {}
    end

    def ping
      rsolr.get('admin/ping')['status']
    rescue
      nil
    end

    def schema
      @schema ||= rsolr.get self.options[:luke], :params => { :show => 'schema', :numTerms => 0 }
    rescue
      {}
    end

    def registry
      @registry ||= begin
                      h = {}
                      resp = rsolr.get self.options[:registry], :params => { :wt => 'xml' }
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
      (schema || {})['index'] || {}
    end

    def to_h
      index#.merge(registry)
    end

    def numDocs; index[:numDocs] || index['numDocs']; end

    def preflight request
      @schema = nil
      @registry = nil

      super
    end
  end
end
