Gem::Specification.new do |s|
  s.name        = 'clickity'
  s.version     = '0.0.5'
  s.date        = '2013-10-01'
  s.summary     = "Bindings for clickity.io "
  s.description = "Gem containing ruby bindings for the clickity.io mail testing api."
  s.authors     = ["Clickity Ltd"]
  s.email       = 'support@clickity.io'
  s.files       = ['lib/clickity.rb',
                   'lib/clickity/attachment.rb',
                   'lib/clickity/email.rb',
                   'lib/clickity/email_address.rb',
                   'lib/clickity/email_data.rb',
                   'lib/clickity/link.rb']
  s.homepage    =
    'http://clickity.io'
  s.license       = 'MIT'

  s.add_dependency "json", ["= 1.7.6"]
  s.add_dependency "mime-types", ["= 1.25"]
  s.add_dependency "rest-client", ["= 1.6.7"]
end
