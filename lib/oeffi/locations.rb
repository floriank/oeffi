module Locations
  class Location
    STATION = 0
    ADDRESS = 1
    POI     = 2
    ANY     = 3

    def initialize(javaStation)
      @type = Location::const_get javaStation.type.to_s
      @id   = javaStation.id
      @name = javaStation.name
      @lat  = javaStation.lat.to_f / 1000000
      @lng  = javaStation.lon.to_f / 1000000
    end
  end
end
