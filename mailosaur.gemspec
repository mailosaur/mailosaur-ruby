require 'rake'
Gem::Specification.new do |s|
  s.name        = 'mailosaur'
  s.version     = '0.0.10'
  s.date        = '2014-07-26'
  s.summary     = 'Bindings for mailosaur.com'
  s.description = 'Gem containing ruby bindings for the mailosaur.com mail testing api.'
  s.authors     = ['Clickity Ltd']
  s.email       = 'support@mailosaur.com'
  s.homepage    = 'http://mailosaur.com'
  s.license     = 'MIT'

  s.files       = Dir['LICENSE', 'README.md', 'lib/mailosaur.rb', 'lib/**/*']
  s.add_dependency 'json', ['= 1.7.6']
  s.add_dependency 'mime-types', ['= 1.25']
  s.add_dependency 'rest-client', ['~> 1.7']


  s.add_development_dependency 'mail', ['= 2.6.1']
  s.add_development_dependency 'rake', ['= 10.3.2']
  s.test_files  = Dir['test/**/*']

end
