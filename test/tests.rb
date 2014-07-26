gem 'test-unit'#, '>= 2.1.1' #startup
require 'test/unit'
require 'mail'
require 'mailosaur'
require 'securerandom'

class MailosaurTest < Test::Unit::TestCase

  def test_mailosaur1
     # TODO: retrieve sent email through Mailosaur API and verify it's contents.
  end
end

config = File.readlines('test/mailbox.settings')
mailboxid = config [0]
apikey = config [1]
mailbox = Mailosaur.new(mailboxid, apikey)

RecipientAddressShort = SecureRandom.hex + '.' + mailboxid + '@mailosaur.in'
RecipientAddressLong = 'anybody<' + RecipientAddressShort + '>'


options = { :address              => 'mailosaur.com',
            :port                 => 25,
            :enable_starttls_auto => true  }



Mail.defaults do
  delivery_method :smtp, options
end

def sendTestEmails(to)

  @mail = Mail.new do
    to      to
    from    'anyone<anyone@example.com>'
    subject 'test subject'

    text_part do
      body "this is a test.\n\nthis is a link: mailosaur <https://mailosaur.com/>\n\nthis is an image:[image: Inline image 1] <https://mailosaur.com/>\n\nthis is an invalid link: invalid"
    end

    add_file 'test/logo-m.png'
    add_file 'test/logo-m-circle-sm.png'

    inline = attachments['logo-m.png']


    html_part do
      content_type 'text/html; charset=UTF-8'
      body "<div dir=\"ltr\"><img src=\"https://mailosaur.com/favicon.ico\" /><div style=\"font-family:arial,sans-serif;font-size:13px;color:rgb(80,0,80)\">this is a test.</div><div style=\"font-family:arial,sans-serif;font-size:13px;color:rgb(80,0,80)\"><br>this is a link: <a href=\"https://mailosaur.com/\" target=\"_blank\">mailosaur</a><br>\n</div><div class=\"gmail_quote\" style=\"font-family:arial,sans-serif;font-size:13px;color:rgb(80,0,80)\"><div dir=\"ltr\"><div><br></div><div>this is an image:<a href=\"https://mailosaur.com/\" target=\"_blank\"><img src=\"cid:#{inline.cid}\" alt=\"Inline image 1\"></a></div>\n<div><br></div><div>this is an invalid link: <a href=\"http://invalid/\" target=\"_blank\">invalid</a></div></div></div>\n</div>"
    end

  end

    @mail.deliver



end

sendTestEmails(RecipientAddressLong)