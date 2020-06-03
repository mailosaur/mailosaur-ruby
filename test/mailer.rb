require 'mail'
require 'securerandom'

Mail.defaults do
    delivery_method :smtp, {
      address: ENV['MAILOSAUR_SMTP_HOST'] || 'mailosaur.io',
      port: ENV['MAILOSAUR_SMTP_PORT'] || 25,
      enable_starttls_auto: false
    }
end

class Mailer
    @@html = File.open('test/resources/testEmail.html').read
    @@text = File.open('test/resources/testEmail.txt').read

    def self.send_emails(client, server, quantity)
        (1..quantity).each do |_i|
            send_email(client, server)
        end

        # Allow 2 seconds for any SMTP processing
        sleep 2
    end

    def self.send_email(client, server, send_to_address = nil)
        Mail.deliver do
            random_string = SecureRandom.hex(5)

            subject '%s subject' % [random_string]
            random_to_address = send_to_address || client.servers.generate_email_address(server)

            from '%s %s <%s>' % [random_string, random_string, client.servers.generate_email_address(server)]
            to '%s %s <%s>' % [random_string, random_string, random_to_address]

            text_part do
                body @@text.to_s.gsub('REPLACED_DURING_TEST', random_string)
            end

            html_part do
                content_type 'text/html; charset=UTF-8'
                body @@html.to_s.gsub('REPLACED_DURING_TEST', random_string)
            end

            add_file 'test/resources/cat.png'
            add_file 'test/resources/dog.png'

            inline = attachments['cat.png']
            inline.content_id = 'ii_1435fadb31d523f6'
        end
    end
end
