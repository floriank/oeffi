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
end