require "oeffi/locations"
module Queries
  include Locations
  class Query
    def perform(method, args)
      Oeffi.provider.send(method, *args)
    end
  end

  class AutocompleteQuery < Query
    attr_accessor :string
    def initialize(string)
      @string = string
    end

    def perform
      result = super :autocompleteStations, [@string]
      result.to_a.map do |station|
        Locations::Location.new station
      end
    end
  end

  def self.get_type(identifier)
    Java::DeSchildbachPteDto::LocationType::const_get identifier.to_s
  end
end
