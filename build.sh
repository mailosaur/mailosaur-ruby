#!/bin/sh

# Clean output directory, excluding customised files
mv lib/Mailosaur/mailosaur_error.rb mailosaur_error.rb.tmp
rm -rf lib/*

# Rebuild generated code
autorest

# Relocate generated code
mv lib/generated/* lib/
rm -rf lib/generated
sed -i "" s/generated\\/// lib/mailosaur.rb

# Replace customised files
mv mailosaur_error.rb.tmp lib/Mailosaur/mailosaur_error.rb
rm -f lib/Mailosaur/models/mailosaur_error.rb

# Use MailosaurError rather than MsRest::HttpOperationError
error_handling='mailosaur_error = Mailosaur::MailosaurError.new('"'"'Operation returned an invalid status code '"\\\''"' + status_code.to_s + '"'\\\''"', error_model)\
          raise mailosaur_error'
for f in `find lib -type f -name "*.rb"`
do
  sed -i '' "s/fail\ MsRest::HttpOperationError.*/${error_handling}/" "$f"
done

# Customise lib/mailosaur.rb with items such as MailosaurClient class
# and generate_email_address method. Remove generated code comment.
sed -i '' -e '1,7d' lib/mailosaur.rb
sed -i '' -e '$d' lib/mailosaur.rb
sed -i '' -e '/:MailosaurError/d' lib/mailosaur.rb
sed -i '' '/:MailosaurBaseClient/ a\
autoload :MailosaurError,                                     '"'"'Mailosaur/mailosaur_error.rb'"'"'\
' lib/mailosaur.rb
echo "
  class MailosaurClient < MailosaurBaseClient
    def initialize(api_key, base_url = 'https://mailosaur.com/')
      credentials = MsRest::BasicAuthenticationCredentials.new(api_key, '')
      super(credentials, base_url, nil)
    end
  end

  # Monkey patch generate_email_address method
  class Servers
    def generate_email_address(server)
      host = ENV['MAILOSAUR_SMTP_HOST'] || 'mailosaur.io'
      '%s.%s@%s' % [SecureRandom.hex(3), server, host]
    end
  end
end" >> lib/mailosaur.rb

# Update files_operations to prevent optimistic deserializing
sed -i '' 's/parsed\_response\ =.*/parsed_response = response_content/' lib/Mailosaur/files.rb

# Update dependencies
bundle install