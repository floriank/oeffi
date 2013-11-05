# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'oeffi/version'

Gem::Specification.new do |spec|
  spec.name          = "oeffi"
  spec.version       = Oeffi::VERSION
  spec.authors       = ["Florian Kraft"]
  spec.email         = ["floriankraft@gmx.de"]
  spec.description   = %q{The public transport enabler library as a gem for JRuby}
  spec.summary       = %q{Oeffi for JRuby}
  spec.homepage      = "https://github.com/floriank/oeffi"
  spec.license       = "GPLv3"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "geokit"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
end
