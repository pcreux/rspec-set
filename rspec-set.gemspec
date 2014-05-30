# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'version'

Gem::Specification.new do |spec|
  spec.name          = "rspec-set"
  spec.version       = Rspec::RSpecSet::VERSION
  spec.authors       = ["Philippe Creux"]
  spec.email         = ["pcreux@gmail.com"]
  spec.description   = "#set(), speed-up your specs"
  spec.summary       = "#set() is a helper for RSpec which setup active record
                        objects before all tests and restore them to there original state 
                        before each test"
  spec.homepage      = "http://github.com/pcreux/rspec-set"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.14.1"
  spec.add_development_dependency "database_cleaner"
  spec.add_development_dependency "activerecord"
  spec.add_development_dependency "sqlite3"
end
