# vim: sw=2 et

require File.expand_path('../lib/itunes_validator', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'itunes_validator'
  s.license     = 'MPL-2.0'
  s.version     = ItunesValidator::VERSION
  s.authors     = ['Scott Talbot']
  s.email       = 's@chikachow.org'
  s.summary     = 'iTunes Receipt validation'
  s.homepage    = 'https://github.com/cysp/itunes_validator-ruby'
  s.description = 'iTunes Receipt validation. Sends an app or transaction receipt to app store and sends back a collection of objects representing either the receipt for the last purchased item, or the entire app receipt.'

  meta_files    = %w| LICENSE README.md Rakefile itunes_validator.gemspec |
  lib_files     = %w| lib/itunes_validator.rb lib/itunes_validator/client.rb lib/itunes_validator/app_receipt.rb lib/itunes_validator/item_receipt.rb|
  test_files    = %w| test/coverage.rb test/test_itunes_validator.rb |
  s.test_files  = test_files.select{ |f| File.extname(f) == 'rb' && File.basename(f).start_with?('test_') }
  s.files       = meta_files + lib_files + test_files

  s.add_development_dependency 'rake', '~> 0'
end
