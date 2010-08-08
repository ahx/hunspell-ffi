# encoding: utf-8
Gem::Specification.new do |s|
  s.name        = 'hunspell-ffi'
  s.version     = '0.1.3.alpha'
  s.date        = '2010-08-6'
  s.authors     = ["Andreas Haller"]
  s.email       = ["andreashaller@gmail.com"]
  s.homepage    = "http://github.com/ahaller/hunspell-ffi"
  s.summary     = "A Ruby FFI interface to the Hunspell spelling checker"
  s.add_dependency 'ffi', '>= 0.6.3'
  s.required_rubygems_version = ">= 1.3.6"
  s.files       = Dir['test/cakes*'] + Dir['test/*.rb'] + Dir['lib/**/*.rb'] + %w(Rakefile README.rdoc)
  s.test_files  = Dir['test/test_*.rb']
  s.require_path = 'lib'
end
