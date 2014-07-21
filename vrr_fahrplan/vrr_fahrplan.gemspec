# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vrr_fahrplan/version'

Gem::Specification.new do |spec|
  spec.name          = "vrr_fahrplan"
  spec.version       = VrrFahrplan::VERSION
  spec.authors       = ["superr4y"]
  spec.email         = ["superr4y@gmail.com"]
  spec.summary       = %q{VRR Online Fahrplanuaskunft query}
  spec.description   = %q{With this gem you can query the live vrr online "fahrplanauskunft"}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
