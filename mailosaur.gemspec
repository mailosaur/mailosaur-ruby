Gem::Specification.new do |s|
  s.name        = 'mailosaur'
  s.version     = '0.0.6'
  s.date        = '2014-12-01'
  s.summary     = "Bindings for mailosaur.com"
  s.description = "Gem containing ruby bindings for the mailosaur.com mail testing api."
  s.authors     = ["Clickity Ltd"]
  s.email       = 'support@mailosaur.com'
  s.files       = ['lib/mailosaur.rb',
                   'lib/mailosaur/attachment.rb',
                   'lib/mailosaur/email.rb',
                   'lib/mailosaur/email_address.rb',
                   'lib/mailosaur/email_data.rb',
                   'lib/mailosaur/link.rb']
  s.homepage    =
    'http://mailosaur.com'
  s.license       = 'MIT'

  s.add_dependency "json", ["= 1.7.6"]
  s.add_dependency "mime-types", ["= 1.25"]
  s.add_dependency "rest-client", ["= 1.6.7"]
end
