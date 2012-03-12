# encoding: utf-8
Gem::Specification.new do |s|
  s.name        = 'hunspell-ffi'
  s.version     = '0.1.3.alpha3'
  s.date        = '2011-03-23'
  s.authors     = ["Andreas Haller"]
  s.email       = ["andreashaller@gmail.com"]
  s.homepage    = "http://github.com/ahx/hunspell-ffi"
  s.summary     = "A Ruby FFI interface to the Hunspell spelling checker"
  
  s.add_dependency 'ffi', '~> 1.0.7'
  s.required_rubygems_version = ">= 1.3.6"
  
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
end
