# Mailosaur Ruby Client Library

[Mailosaur](https://mailosaur.com) allows you to automate tests involving email. Allowing you to perform end-to-end automated and functional email testing.

[![](https://github.com/mailosaur/mailosaur-ruby/workflows/CI/badge.svg)](https://github.com/mailosaur/mailosaur-ruby/actions)

## Installation

```
gem install mailosaur
```

## Documentation and usage examples

[Mailosaur's documentation](https://mailosaur.com/docs) includes all the information and usage examples you'll need.

## Running tests

Once you've cloned this repository locally, you can simply run:

```
bundle install

export MAILOSAUR_API_KEY=your_api_key
export MAILOSAUR_SERVER=server_id

bundle exec rake test
```

## Linting code

Simply run Rubocop:

```
bundle install
bundle exec rubocop
```

## Contacting us

You can get us at [support@mailosaur.com](mailto:support@mailosaur.com)
