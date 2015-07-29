$:.unshift File.join(File.dirname(__FILE__), 'lib')
require 'rosette/data_stores/in_memory/version'

Gem::Specification.new do |s|
  s.name     = "rosette-datastore-memory"
  s.version  = ::Rosette::DataStores::InMemoryDataStore::VERSION
  s.authors  = ["Cameron Dutro"]
  s.email    = ["camertron@gmail.com"]
  s.homepage = "http://github.com/camertron"

  s.description = s.summary = "An in-memory datastore for the Rosette internationalization platform (mostly for testing purposes)"

  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true

  s.add_dependency 'activemodel', '~> 3.2'

  s.require_path = 'lib'
  s.files = Dir["{lib,spec}/**/*", "Gemfile", "History.txt", "README.md", "Rakefile", "rosette-datastore-memory.gemspec"]
end
