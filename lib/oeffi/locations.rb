java_import "de.schildbach.pte.dto.Location"
require "geokit"

module Locations
  class Location
    attr_accessor :id, :type, :name, :lat, :lon, :loc
    alias_method :distance_to!, :loc=
    STATION = 0
    ADDRESS = 1
    POI     = 2
    ANY     = 3

    def initialize(javaStation)
      @type = javaStation.type.to_s
      @id   = javaStation.id
      @name = javaStation.name
      @lat  = javaStation.lat.to_f / 1000000
      @lon  = javaStation.lon.to_f / 1000000
    end

    def as_json
      hash = {}
      [:id, :type, :name, :lat, :lon].each do |sym|
        hash[sym] = self.send sym
      end
      unless @lat.nil? or @loc.nil?
        hash[:distance_to] = distance_to
      end
      return hash
    end

    def distance_to
      return 0 unless @lat > 0 and @lon > 0
      return 0 unless @loc[:lat] > 0 and @loc[:lon] > 0
      from = Geokit::LatLng.new @lat, @lon
      to   = Geokit::LatLng.new loc[:lat], loc[:lon]
      (from.distance_to to, unit: :km) * 1000
    end
  end
end
