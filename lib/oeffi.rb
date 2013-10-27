require "oeffi/version"
require "oeffi/queries"
require "java"
require "pry"

Dir["lib/vendor/*.jar"].each do |file|
  require file
end

module Oeffi
  include_package "de.schildbach.pte"
  include_package "de.schildbach.pte.dto"
  include Queries

  class << self
    attr_accessor :configuration
    def configure(&block)
      self.configuration ||= Configuration.new
      yield(configuration)
    end

    def autocomplete(string="")
      query = Oeffi::AutocompleteQuery.new string
      query.perform
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
        klass = Oeffi::const_get klass
      rescue Exception => e
        raise "Unknown Provider name: #{klass}"
      end
      @provider = klass.new
    end

    def provider
      @provider
    end
  end
end
