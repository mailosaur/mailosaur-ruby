# Mailosaur Ruby Client Library

[Mailosaur](https://mailosaur.com) allows you to automate tests involving email. Allowing you to perform end-to-end automated and functional email testing.

[![Build Status](https://travis-ci.org/mailosaur/mailosaur-ruby.svg?branch=master)](https://travis-ci.org/mailosaur/mailosaur-ruby)

## Installation

```
gem install mailosaur
```

## Documentation and usage examples

[Mailosaur's documentation](https://mailosaur.com/docs) includes all the information and usage examples you'll need.

## Building

1. Install [Node.js](https://nodejs.org/) (LTS)

2. Install [AutoRest](https://github.com/Azure/autorest) using `npm`

```
# Depending on your configuration you may need to be elevated or root to run this. (on OSX/Linux use 'sudo')
npm install -g autorest
```

3. Run the build script

```
./build.sh
```

### AutoRest Configuration

This project uses [AutoRest](https://github.com/Azure/autorest), below is the configuration that the `autorest` command will automatically pick up.

> see https://aka.ms/autorest

```yaml
input-file: https://mailosaur.com/swagger/latest/swagger.json
```

```yaml
ruby:
    output-folder: lib
    add-credentials: true
    sync-methods: essential 
    use-internal-constructors: true
    override-client-name: MailosaurBaseClient
    namespace: Mailosaur
    package-name: Mailosaur
    package-version: 5.0.2
```

## Running tests

Once you've cloned this repository locally, you can simply run:

```
bundle install

export MAILOSAUR_API_KEY=your_api_key
export MAILOSAUR_SERVER=server_id

bundle exec rake test
```

## Contacting us

You can get us at [support@mailosaur.com](mailto:support@mailosaur.com)
