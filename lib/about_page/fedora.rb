module AboutPage
  class Fedora < AboutPage::Configuration::Node

    attr_accessor :fedora

    render_with 'generic_hash'

    validates_each :ping do |record, attr, value|
      unless value == 200
        record.errors.add attr, ": unable to reach Fedora at #{record.fedora_url}"
      end
    end

    def initialize(fedora_instance)
      self.fedora = fedora_instance
    end

    def fedora_info
      resp = fedora.get("/").response.body
      doc = Nokogiri::XML resp

      release = doc.css("span#version").text
      build = doc.css("span#build").text
      timestamp = doc.css("span#timestamp").text

      h = {}
      h["Fedora location"] = fedora.http.url_prefix.to_s
      h["Release"] = release unless release.nil?
      h["Build"] = build unless release.nil?
      h["Timestamp"] = timestamp unless release.nil?
      h
    rescue
      {}
    end

    def ping
      fedora.get("/rest").response.status
    rescue
      nil
    end

    def to_h
      fedora_info
    end

  end
end
