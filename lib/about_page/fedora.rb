begin
  require 'net/http'
  require 'uri'
rescue LoadError
end

module AboutPage
  class Fedora < AboutPage::Configuration::Node

    attr_accessor :fedora_url

    render_with 'generic_hash'

    validates_each :ping do |record, attr, value|
      unless value == 200
        record.errors.add attr, ": unable to reach Fedora at #{record.fedora_url}"
      end
    end

    def initialize(fedora)
      self.fedora_url = fedora.chomp("/rest")
    end

    def fedora_info
      uri = URI.parse(fedora_url)
      response = Net::HTTP.get_response(uri)

      case response
      when Net::HTTPSuccess then
        page = Nokogiri::HTML(response.body)

        release = page.css("span#version").text
        build = page.css("span#build").text
        timestamp = page.css("span#timestamp").text

        h = {}
        h["Release"] = release unless release.nil?
        h["Build"] = build unless release.nil?
        h["Timestamp"] = timestamp unless release.nil?
        h
      else
        {}
      end
    end

    def ping
      ActiveFedora.fedora.connection.get("/rest").response.status
    rescue
      nil
    end

    def to_h
      fedora_info
    end

  end
end
