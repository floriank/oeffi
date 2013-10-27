module Trips
  class Trip
    include_package "de.schildbach.pte.dto.Trip"

    attr_accessor :trip
    def initialize(j_trip)
      @trip = j_trip
    end

    def as_json
      result = {
        :id        => @trip.id,
        :from      => @trip.from.to_s,
        :to        => @trip.to.to_s,
        :departure => @trip.get_first_public_leg_departure_time.getTime,
        :arrival   => @trip.get_last_public_leg_arrival_time.getTime,
        :legs => legs.to_a.map { |leg|
          leg_json leg
        }
      }
    end

    def method_missing(method, *args)
      @trip.send method
    end

  private
    def construct_stop(stop)
      factor = 1000000.0
      {
        :label    => stop.location.to_s,
        :position => {
          :lat => stop.location.lat / factor,
          :lng => stop.location.lon / factor
        },
        :arrival => {
          :time      => stop.get_arrival_time.nil? ? nil : stop.get_arrival_time.getTime,
          :delay     => stop.get_arrival_delay.to_i
        },
        :departure => {
          :time  => stop.get_departure_time.nil? ? nil : stop.get_departure_time.getTime,
          :delay => stop.get_departure_delay.to_i
        }
      }
    end

    def stops(leg)
      start = [construct_stop(leg.departureStop)]
      intermediate = leg.intermediateStops.to_a.map do |stop|
        construct_stop(stop)
      end
      endStop = [construct_stop(leg.arrivalStop)]
      start + intermediate + endStop
    end

    def leg_json(leg)
      if leg.class == Public
        {
          :label     => leg.line.label,
          :delays    => {
            :departure => leg.get_departure_delay.to_i,
            :arrival   => leg.get_arrival_delay.to_i
          },
          :stops       => stops(leg),
          :destination => leg.destination.to_s,
          :path        => leg.path.to_a,
          :type   => leg.class.name.split('::').last
        }
      else
        {
          :type      => leg.type.to_s,
          :distance  => leg.distance
        }
      end
    end
  end

  class TripList
    attr_accessor :list

    def initialize(array = [])
      @list = array.map do |trip|
        Trip.new trip
      end
    end

    def as_json
      @list.map(&:as_json)
    end

    def empty?
      @list.count == 0
    end
  end
end