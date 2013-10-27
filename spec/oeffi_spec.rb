require "spec_helper"
require "lib/oeffi"

describe "Oeffi module" do
  it "should exist" do
    Oeffi.should_not be_nil
  end

  it "should have a configurable Provider" do
    Oeffi.configure do |oeffi|
      oeffi.provider = :nasa
    end

    Oeffi.configuration.provider.class.name.split("::").last.should eql "NasaProvider"

    Oeffi.configure do |oeffi|
      oeffi.provider = :vbb
    end

    Oeffi.configuration.provider.class.name.split("::").last.should eql "VbbProvider"
  end

  it "should throw an error when trying to configure an unknown provider" do
    expect {
      Oeffi.configure do |oeffi|
        oeffi.provider = :foo
      end
    }.to raise_error
  end

  describe "autocomplete" do
    it "should provide a method to autocomplete based on a given string" do
      result = Oeffi::autocomplete("Leipzig")
      result.should be_a Array
    end

    it "should provide a set of Stations for when autocompleting" do
      result = Oeffi::autocomplete("Halle")
      result.should_not be_empty
      result.each do |res|
        res.should be_a Oeffi::Location
      end
    end
  end

  describe "Trip finding" do
    before :each do
      Oeffi.configure do |oeffi|
        oeffi.provider = :nasa
      end
    end
    it "should provide a method for querying trips" do
      stations = {
        :from => {
          :id => 10789,
          :type => "STATION"
        },
        :to => {
          :id => 11345,
          :type => "STATION"
        }
      }
      expect {
        Oeffi::find_trips stations
      }.not_to raise_error

    end

    it "should handle string values for a departure date" do
      stations = {
        :from => {
          :id => 10789,
          :type => "STATION"
        },
        :to => {
          :id => 11345,
          :type => "STATION"
        },
        :date => "2013-12-25 18:00:00"
      }

      expect {
        Oeffi::find_trips stations
      }.not_to raise_error

    end

    it "should expose a switch for departure or arrival time" do
      stations = {
        :from => {
          :id => 10789,
          :type => "STATION"
        },
        :to => {
          :id => 11345,
          :type => "STATION"
        },
        :date => "2013-12-25 18:00:00",
        :departure => false # date is now set for arrival
      }

      expect {
        Oeffi::find_trips stations
      }.not_to raise_error

    end
  end
end
