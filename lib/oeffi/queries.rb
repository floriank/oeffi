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

  class NearbyQuery < Query
    attr_accessor :lat, :lon
    def initialize(opts)
      @lat = opts[:lat]
      @lon = opts[:lon]
    end

    def perform
      factor   = 1000000
      location = Java::DeSchildbachPteDto::Location.new Queries::get_type(:ANY), (@lat*factor).to_i, (@lon*factor).to_i
      result   = super :queryNearbyStations, [location, 5000, 100]
      return [] unless result.status.to_s == "OK"
      result.stations.to_a.map do |station|
        Locations::Location.new station
      end
    end
  end

  def self.get_type(identifier)
    Java::DeSchildbachPteDto::LocationType::const_get identifier.to_s
  end
end
