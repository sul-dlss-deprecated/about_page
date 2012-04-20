module AboutPage
  class Solr
    delegate :each_pair, :to_json, :to_xml, :to => :to_h

    attr_accessible :rsolr

    def initialize rsolr_instance
      self.rsolr = rsolr_instance
    end

    def to_h
      rsolr.luke(:show => 'schema', :numTerms => 0)['index']
    end
  end
end
