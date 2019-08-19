require 'rake'
require './lib/Mailosaur/version'

Gem::Specification.new do |s|
  s.name        = 'mailosaur'
  s.version     = Mailosaur::VERSION
  s.required_ruby_version = '>= 2.2'
  s.summary     = 'Ruby client library for Mailosaur'
  s.description = 'Ruby client library for Mailosaur.'
  s.authors     = ['Mailosaur Ltd']
  s.email       = 'code@mailosaur.com'
  s.homepage    = 'https://mailosaur.com'
  s.license     = 'MIT'

  s.files       = Dir['LICENSE', 'README.md', 'lib/mailosaur.rb', 'lib/**/*']
  s.add_dependency 'faraday', '<= 1.0', '>= 0.9.0'
  s.add_dependency 'json', '<= 3.0', '>= 1.7.5'

  s.add_development_dependency 'mail', '~> 2.6', '>= 2.6.1'
  s.add_development_dependency 'rake', '~> 12.3', '>= 12.3.0'
  s.add_development_dependency 'rubocop', '~> 0.68.0'
  s.add_development_dependency 'shoulda-context', '~> 1.2', '>= 1.2.2'
  s.add_development_dependency 'test-unit', '~> 3.2', '>= 3.2.7'
end
