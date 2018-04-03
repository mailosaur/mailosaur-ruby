require 'rake'
Gem::Specification.new do |s|
  s.name        = 'mailosaur'
  s.version     = '5.0.2'
  s.date        = '2018-01-28'
  s.summary     = 'Client library for Mailosaur'
  s.description = 'Gem containing ruby client library for Mailosaur.'
  s.authors     = ['Mailosaur Ltd']
  s.email       = 'support@mailosaur.com'
  s.homepage    = 'https://mailosaur.com'
  s.license     = 'MIT'

  s.files       = Dir['LICENSE', 'README.md', 'lib/mailosaur.rb', 'lib/**/*']
  s.add_dependency 'json', '<= 3.0', '>= 1.7.5'
  s.add_dependency 'ms_rest', '= 0.7.2'
  s.add_dependency 'faraday', '<= 1.0', '>= 0.9.0'
  s.add_dependency 'faraday-cookie_jar', '~> 0.0.6'

  s.add_development_dependency 'rake', '>= 10.5.0'
  s.add_development_dependency 'mail', '~> 2.6.1'
  s.add_development_dependency 'shoulda-context', '~> 1.2.2'
  s.add_development_dependency 'test-unit', '~> 3.2.7'
end
