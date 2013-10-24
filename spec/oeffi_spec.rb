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
    it "should provider a method to autocomplete based on a given string" do
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
end
