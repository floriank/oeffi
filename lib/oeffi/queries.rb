require "oeffi/locations"
require "oeffi/trips"

module Queries
  include Locations
  include Trips
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

  class TripQuery < Query
    include_package "de.schildbach.pte"
    include_package "de.schildbach.pte.dto"
    attr_accessor :from, :to, :via, :count, :departure, :date, :address

    def initialize(opts)
      defaults = {
        :count     => 4,
        :departure => true,
        :date      => java.util.Date.new
      }
      opts = defaults.merge opts
      opts.each do |k,v|
        self.send "#{k}=", v
      end

      raise "no From Location given!" if @from.nil?
      raise "no To Location given!" if @to.nil?
      unless @date.class == java.util.Date
        @date = java.util.Date.new(Time.parse(@date).to_i * 1000)
      end
    end

    def perform
      result = super :queryTrips, [fromLocation, viaLocation, toLocation, date, departure, count, products, walkspeed, accessibility, nil]
      Trips::TripResult.new result.trips.to_a
    end

  private
    ###
    #
    # These are not "products" as in tickets, these are transportation types, such as "BUS" or "TRAIN"
    #
    ###
    def products(which = :all)
      Product::const_get which.to_s.upcase
    end

    def walkspeed(type = :normal)
      NetworkProvider::WalkSpeed::const_get type.to_s.upcase
    end

    def accessibility(type = :neutral)
      NetworkProvider::Accessibility::const_get type.to_s.upcase
    end

    def fromLocation
      location :from
    end

    def toLocation
      location :to
    end

    def viaLocation
      return nil if @via.nil?
      location :via
    end

    def location(sym)
      values = self.send sym.to_s
      type   = LocationType::const_get values[:type].to_s
      if values[:id].nil? # consider this an address
        lat = (values[:lat] * 1000000).to_i
        lon = (values[:lon] * 1000000).to_i
        Location.new type, lat, lon
      else
        Location.new type, values[:id]
      end
    end
  end

  def self.get_type(identifier)
    LocationType::const_get identifier.to_s
  end
end
