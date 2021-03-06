require File.dirname(__FILE__) + "/lib/bwcli/version"

Gem::Specification.new do |s|
  s.name        = 'bwcli'
  s.version     = BWCLI::VERSION
  s.date        = '2013-09-17'
  s.summary     = 'Brandwatch CLI'
  s.description = 'A CLI interface to interact with the Brandwatch v2 API'
  s.author      = 'Jonathan Chrisp'
  s.email       = 'jonathan@brandwatch.com'
  s.license     = 'MIT'
  s.homepage    = 'https://github.com/jonathanchrisp/bwcli'
  s.required_ruby_version = ">= 1.9.2"

  s.add_development_dependency 'rspec', '~> 2.13.0'
  s.add_development_dependency 'pry', '~> 0.9.12.2'

  s.add_runtime_dependency 'bwapi', '~> 1.0.6'
  s.add_runtime_dependency 'thor', '~> 0.18.1'
  s.add_runtime_dependency 'awesome_print', '~> 1.1.0'
  s.add_runtime_dependency 'hashie', '~> 2.0.5'

  s.files         = `git ls-files`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.test_files    = `git ls-files -- spec/*`.split("\n")
  s.require_paths = ['lib']
end