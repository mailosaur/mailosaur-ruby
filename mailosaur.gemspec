require 'rake'
Gem::Specification.new do |s|
  s.name        = 'mailosaur'
  s.version     = '3.0.1'
  s.date        = '2017-10-16'
  s.summary     = 'Client library for Mailosaur'
  s.description = 'Gem containing ruby client library for Mailosaur.'
  s.authors     = ['Mailosaur Ltd']
  s.email       = 'support@mailosaur.com'
  s.homepage    = 'https://mailosaur.com'
  s.license     = 'MIT'

  s.files       = Dir['LICENSE', 'README.md', 'lib/mailosaur.rb', 'lib/**/*']
  s.add_dependency 'json', ['>= 1.7.6']
  s.add_dependency 'mime-types', ['>= 1.16']
  s.add_dependency 'rest-client', ['>= 2.0.1']

  s.add_development_dependency 'mail', ['>= 2.6.1']
  s.add_development_dependency 'rake', ['>= 10.4.2']
  s.add_development_dependency 'pry', ['>= 0.10.4']
  s.add_development_dependency 'minitest', ['>= 5.8.4']
end
