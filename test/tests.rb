gem 'test-unit'#, '>= 2.1.1' #startup
require 'test/unit'
require 'mail'
require 'mailosaur'
require 'securerandom'



options = { :address              => 'mailosaur.com',
            :port                 => 25,
            :enable_starttls_auto => true  }



Mail.defaults do
  delivery_method :smtp, options
end

class MailosaurTest < Test::Unit::TestCase
  @@recipientAddressShort = nil
  @@recipientAddressLong = nil
  @@mailbox = nil

  def self.setup
    config = File.readlines('test/mailbox.settings')
    mailboxid = config[0].strip
    apikey = config[1].strip
    @@mailbox = Mailosaur.new(mailboxid, apikey)

    @@recipientAddressShort = SecureRandom.hex + '.' + mailboxid + '@mailosaur.in'
    #@@recipientAddressShort = 'testRuby.' + mailboxid + '@mailosaur.in'

    @@recipientAddressLong = 'anybody<' + @@recipientAddressShort + '>'


    sendTestEmails()
  end

  def test_getEmailsTest()
    emails = @@mailbox.getEmails()
    assertEmail(emails[0])
  end

  def test_getEmailsSearchTest()
    emails = @@mailbox.getEmails('test')
    assertEmail(emails[0])
  end

  def test_getEmailsByRecipientTest()
    emails = @@mailbox.getEmailsByRecipient(@@recipientAddressShort)
    assertEmail(emails[0])
  end

  def assertEmail(email)

    # html links:
    assert_equal(3, email.html.links.length)
    assert_equal('https://mailosaur.com/', email.html.links[0].href)
    assert_equal('mailosaur', email.html.links[0].text)
    assert_equal('https://mailosaur.com/', email.html.links[1].href)
    assert_equal(nil, email.html.links[1].text)
    assert_equal('http://invalid/', email.html.links[2].href)
    assert_equal('invalid', email.html.links[2].text)

    # html images:
    assert(email.html.images[1].src.end_with?('.png'))
    assert_equal('Inline image 1', email.html.images[1].alt)

    # html body:
    body = "<div dir=\"ltr\"><img src=\"https://mailosaur.com/favicon.ico\" /><div style=\"font-family:arial,sans-serif;font-size:13px;color:rgb(80,0,80)\">this is a test.</div><div style=\"font-family:arial,sans-serif;font-size:13px;color:rgb(80,0,80)\"><br>this is a link: <a href=\"https://mailosaur.com/\" target=\"_blank\">mailosaur</a><br>\n</div><div class=\"gmail_quote\" style=\"font-family:arial,sans-serif;font-size:13px;color:rgb(80,0,80)\"><div dir=\"ltr\"><div><br></div><div>this is an image:<a href=\"https://mailosaur.com/\" target=\"_blank\"><img src=\"cid:inline_cid\" alt=\"Inline image 1\"></a></div>\n<div><br></div><div>this is an invalid link: <a href=\"http://invalid/\" target=\"_blank\">invalid</a></div></div></div>\n</div>"
    #body = body.Replace((char)32, (char)160)
    #email.html.Body = email.html.Body.Replace((char)32, (char)160)
    assert_equal(body, email.html.body)

    # text links:
    assert_equal(2, email.text.links.length)
    assert_equal("https://mailosaur.com/", email.text.links[0].href)
    assert_equal("https://mailosaur.com/", email.text.links[0].text)
    assert_equal("https://mailosaur.com/", email.text.links[1].href)
    assert_equal("https://mailosaur.com/", email.text.links[1].text)

    # text body:
    text = "this is a test.\n\nthis is a link: mailosaur <https://mailosaur.com/>\n\nthis is an image:[image: Inline image 1] <https://mailosaur.com/>\n\nthis is an invalid link: invalid"

    #text = text.Replace((char)32, (char)160)
    #email.text.Body = email.text.Body.Replace((char)32, (char)160)
    assert_equal(text, email.text.body)

    #headers:
    assert(email.headers['received'].start_with?('from'))
    assert_equal('anyone <anyone@example.com>', email.headers['from'])
    assert_equal('anybody <' + @@recipientAddressShort + '>', email.headers['to'])
    assert_not_nil(email.headers['date'])
    assert_equal('test subject', email.headers['subject'])

    #properties:
    assert_equal('test subject', email.subject)
    assert_equal('normal', email.priority)

    assert(email.creationdate.year > 2013)
    assert_not_nil(email.senderHost)
    assert_not_nil(email.mailbox)

    #raw eml:
    assert_not_nil(email.rawId)
    eml = @@mailbox.getRawEmail(email.rawId)
    assert_not_nil(eml)
    assert(eml.length > 1)
    assert(eml.start_with?('Received') || eml.start_with?('Authentication'))


    #from:
    assert_equal('anyone@example.com', email.from[0].address)
    assert_equal('anyone', email.from[0].name)

    #to:
    assert_equal(@@recipientAddressShort, email.to[0].address)
    assert_equal('anybody', email.to[0].name)

    #attachments:
    assert_equal(2, email.attachments.length, 'there should be 2 attachments')

    #attachment 1:
    attachment1 = email.attachments[0]
    assert_not_nil(attachment1.id)
    #assert(attachment1.Id.EndsWith(".png"))
    assert_equal(4819, attachment1.length)
    #assert_equal("logo-m.png", attachment1.FileName)

    assert_equal("image/png", attachment1.contentType)

    #var data1 = Mailbox.GetAttachment(attachment1.Id)
    #assert_not_nil(data1)

    #attachment 2:
    attachment2 = email.attachments[1]
    assert(attachment2.id.end_with?('logo-m-circle-sm.png'))
    assert_equal(5260, attachment2.length)
    assert_equal('logo-m-circle-sm.png', attachment2.fileName)
    assert_equal('image/png', attachment2.contentType)

    data2 = @@mailbox.getAttachment(attachment2.id)
    assert_not_nil(data2)
    assert_equal(attachment2.length, data2.length)

  end

  def self.sendTestEmails()

    @mail = Mail.new do
      to      @@recipientAddressLong
      from    'anyone<anyone@example.com>'
      subject 'test subject'

      text_part do
        body "this is a test.\n\nthis is a link: mailosaur <https://mailosaur.com/>\n\nthis is an image:[image: Inline image 1] <https://mailosaur.com/>\n\nthis is an invalid link: invalid"
      end

      add_file 'test/logo-m.png'
      add_file 'test/logo-m-circle-sm.png'

      inline = attachments['logo-m.png']
      inline.content_id = 'inline_cid'

      html_part do
        content_type 'text/html; charset=UTF-8'
        body "<div dir=\"ltr\"><img src=\"https://mailosaur.com/favicon.ico\" /><div style=\"font-family:arial,sans-serif;font-size:13px;color:rgb(80,0,80)\">this is a test.</div><div style=\"font-family:arial,sans-serif;font-size:13px;color:rgb(80,0,80)\"><br>this is a link: <a href=\"https://mailosaur.com/\" target=\"_blank\">mailosaur</a><br>\n</div><div class=\"gmail_quote\" style=\"font-family:arial,sans-serif;font-size:13px;color:rgb(80,0,80)\"><div dir=\"ltr\"><div><br></div><div>this is an image:<a href=\"https://mailosaur.com/\" target=\"_blank\"><img src=\"cid:inline_cid\" alt=\"Inline image 1\"></a></div>\n<div><br></div><div>this is an invalid link: <a href=\"http://invalid/\" target=\"_blank\">invalid</a></div></div></div>\n</div>"
      end

    end
    @mail.deliver

  end

end

MailosaurTest.setup