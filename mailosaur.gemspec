require 'rake'
require './lib/Mailosaur/version'

Gem::Specification.new do |s|
  s.name        = 'mailosaur'
  s.version     = Mailosaur::VERSION
  s.required_ruby_version = '>= 2.5'
  s.summary     = 'The Mailosaur Ruby library'
  s.description = 'The Mailosaur Ruby library lets you integrate email and SMS testing into your continuous integration process.'
  s.author      = 'Mailosaur'
  s.email       = 'code@mailosaur.com'
  s.homepage    = 'https://mailosaur.com/'
  s.license     = 'MIT'

  s.metadata = {
    'bug_tracker_uri' => 'https://github.com/mailosaur/mailosaur-ruby/issues',
    'documentation_uri' => 'https://mailosaur.com/docs/email-testing/ruby/',
    'github_repo' => 'ssh://github.com/mailosaur/mailosaur-ruby',
    'homepage_uri' => 'https://mailosaur.com/',
    'source_code_uri' => 'https://github.com/mailosaur/mailosaur-ruby'
  }

  s.files = Dir['LICENSE', 'README.md', 'lib/mailosaur.rb', 'lib/**/*']
  s.add_dependency 'faraday', '>= 0.9', '< 2'
  s.add_dependency 'json', '>= 1.7.5', '< 4'

  s.add_development_dependency 'mail', '~> 2.6', '>= 2.6.1'
  s.add_development_dependency 'rake', '~> 13.0'
  s.add_development_dependency 'rubocop', '~> 1.19.0'
  s.add_development_dependency 'shoulda-context', '~> 1.2', '>= 1.2.2'
  s.add_development_dependency 'test-unit', '~> 3.2', '>= 3.2.7'
end
