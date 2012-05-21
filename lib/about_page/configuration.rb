require 'ostruct'

module AboutPage

  class OpenStructWithHashAccess < OpenStruct
    delegate :each, :map, :to => :to_h
    def to_json(options = {})
      Hash[*@table.map { |k, v| [k, v.to_h ] }.flatten ]
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
    delegate :to_xml, :to_h, :to_json, :to => :hash
    delegate :each, :map, :to => :to_h

    def initialize
      @hash = OpenStructWithHashAccess.new
    end

    def method_missing *args
      @hash.send(*args)
    end

     end
end
