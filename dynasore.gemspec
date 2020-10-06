$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "dynasore/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.authors     = ["Rick Cobb"]
  s.description = "Simple configuration of aws-record"
  s.email       = ["rick@grandrounds.com"]
  s.files         = `git ls-files -z`.split("\x0")
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.homepage      = 'https://github.com/ConsultingMD/dynasore'
  s.license     = "MIT"
  s.name          = 'dynasore'
  s.require_paths = ['lib']
  s.summary       = %q{Rails-ish configuration and add-ons for aws-record}
  s.test_files    = s.files.grep(%r{^spec/})
  s.version       = Dynasore::VERSION

  s.add_dependency "rails"
  s.add_dependency 'aws-sdk', '~> 3'
  s.add_dependency 'aws-record'

  s.add_development_dependency 'bundler', '~> 1.7'
  s.add_development_dependency 'rake', '~> 10.0'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'parallel_tests'
  s.add_development_dependency 'byebug'
  s.add_development_dependency 'rack', '~> 1.0' # We support Ruby 2.1.5
  s.add_development_dependency "sqlite3" # Dummy app
end
