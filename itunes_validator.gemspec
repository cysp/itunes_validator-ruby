# vim: sw=2 et

require File.expand_path('../lib/itunes_validator/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'itunes_validator'
  s.license     = 'MPL-2.0'
  s.version     = ItunesValidator::VERSION
  s.authors     = ['Scott Talbot']
  s.email       = 's@chikachow.org'
  s.summary     = 'iTunes Receipt validation'
  s.homepage    = 'https://github.com/cysp/itunes_validator-ruby'

  meta_files    = %w| LICENSE README.md |
  lib_files     = %w| lib/itunes_validator.rb lib/itunes_validator/client.rb lib/itunes_validator/receipt.rb lib/itunes_validator/version.rb |
  s.files       = meta_files + lib_files

  s.add_development_dependency 'rake'
end
