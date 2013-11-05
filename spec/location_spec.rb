require "java"
require "lib/oeffi"

describe Location do
  it "should present it's values as a hash" do
    jLocation = Java::DeSchildbachPteDto::Location.new Java::DeSchildbachPteDto::LocationType::STATION, 13000
    location = Locations::Location.new jLocation

    result = location.as_json
    result.should be_a Hash

    result[:id].should equal 13000
  end

  it "should be able to tell the distance to a certain point" do
    jLocation = Java::DeSchildbachPteDto::Location.new Java::DeSchildbachPteDto::LocationType::STATION, 51344352, 12380712
    location = Locations::Location.new jLocation
    location.distance_to!({lat: 51.3394580, :lon => 12.3745350})
    location.distance_to.should be_within(100).of 500
  end
end