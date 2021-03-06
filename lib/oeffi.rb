require "java"
require "oeffi/jars"
require "oeffi/version"
require "oeffi/queries"

module Oeffi
  include Queries

  class << self
    attr_accessor :configuration
    def configure(&block)
      self.configuration ||= Configuration.new
      yield(configuration)
    end

    def autocomplete(string="", location={})
      Oeffi::AutocompleteQuery.new(string, location[:lat], location[:lon]).perform
    end

    def find_trips(opts)
      Oeffi::TripQuery.new(opts).perform
    end

    def provider
      Oeffi.configuration.provider
    end
  end

  class Configuration
    attr_writer :provider
    ##
    # Configure a provider for the oeffi module
    #
    # Possible providers:
    # :atc, :avv, :bahn, :bayern, :bsag, :bsvag, :bvb, :bvg, :ding, :dsb, :dub, :eireann, :gvh, :invg, :ivb,
    # :kvv, :linz, :location, :lu, :maribor, :met, :mvg, :mvv, :naldo, :nasa, :nri, :ns, :nvbw, :nvv, :oebb,
    # :pl, :rt, :sad, :sbb, :se, :septa, :sf, :sh, :sncb, :stockholm, :stv, :svv, :sydney, :tfi, :tfl, :tlem,
    # :tlsw, :tlwm, :vagfr, :vbb, :vbl, :vbn, :vgn, :vgs, :vmobil, :vms, :vmv, :vor, :vrn, :vrr, :vrt, :vvm,
    # :vvo, :vvs, :vvt, :vvv, :wien, :zvv
    #
    ##
    def provider=(sym)
      klass = "#{sym.to_s.capitalize}Provider"
      begin
        java_import "de.schildbach.pte.#{klass}"
        @provider = Oeffi::const_get(klass).new
      rescue Exception => e
        raise "Unknown Provider name: #{klass}"
      end
    end

    def provider
      @provider
    end
  end
end
