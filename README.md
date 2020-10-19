# Mailosaur Ruby Client Library

[Mailosaur](https://mailosaur.com) lets you automate email and SMS tests, like account verification and password resets, and integrate these into your CI/CD pipeline.

[![](https://github.com/mailosaur/mailosaur-ruby/workflows/CI/badge.svg)](https://github.com/mailosaur/mailosaur-ruby/actions)

## Installation

```
gem install mailosaur
```

## Documentation

Please see the [Ruby client reference](https://mailosaur.com/docs/email-testing/ruby/client-reference/) for the most up-to-date documentation.

## Usage

example.rb

```ruby
require "mailosaur"
mailosaur = Mailosaur::MailosaurClient.new("YOUR_API_KEY")

result = mailosaur.servers.list()

print("You have a server called: " + result.items[0].name)
```

## Development

You must have the following prerequisites installed:

* [Bundler](https://bundler.io/)

Install all development dependencies:

```sh
bundle install
```

The test suite requires the following environment variables to be set:

```sh
export MAILOSAUR_BASE_URL=https://mailosaur.com/
export MAILOSAUR_API_KEY=your_api_key
export MAILOSAUR_SERVER=server_id
```

Run all tests:

```sh
bundle exec rake test
```

Lint code (via Rubocop):

```sh
bundle exec rubocop
```

## Contacting us

You can get us at [support@mailosaur.com](mailto:support@mailosaur.com)
