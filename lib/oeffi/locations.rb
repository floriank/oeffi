java_import "de.schildbach.pte.dto.Location"

module Locations
  class Location
    attr_accessor :id, :type, :name, :lat, :lon
    STATION = 0
    ADDRESS = 1
    POI     = 2
    ANY     = 3

    def initialize(javaStation)
      @type = javaStation.type.to_s
      @id   = javaStation.id
      @name = javaStation.name
      @lat  = javaStation.lat.to_f / 1000000
      @lng  = javaStation.lon.to_f / 1000000
    end

    def as_json
      hash = {}
      [:id, :type, :name, :lat, :lon].each do |sym|
        hash[sym] = self.send sym
      end
      return hash
    end
  end
end
