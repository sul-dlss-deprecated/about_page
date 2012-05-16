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

  Configuration = OpenStructWithHashAccess.new

 
end
