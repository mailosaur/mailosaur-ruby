require_relative 'test_helper'

class MailosaurTest < Minitest::Test
  extend Minitest::Spec::DSL

  let(:mailbox_id) {ENV['MAILBOX_ID']}
  let(:api_key) {ENV['API_KEY']}
  let(:mailbox) {Mailosaur.new(mailbox_id, api_key)}
  let(:recipient_address_short) { "#{SecureRandom.hex}.#{mailbox_id}@mailosaur.in" }
  let(:recipient_address_long) {"anybody<#{recipient_address_short}>"}
  let(:message_string) { MessageGenerator.new }

  def setup
    send_test_email(recipient_address_long)
    message_string.sleep
    sleep 10
  end

  def test_get_emails
    emails = mailbox.get_emails
    assert_email(emails[0])
  end

  def test_get_emails_search
    emails = mailbox.get_emails('test')
    assert_email(emails[0])
  end

  # fails occasionally, even with timeout
  def test_get_emails_by_recipient
    emails = mailbox.get_emails_by_recipient(recipient_address_short)
    assert_email(emails[0])
  end

  def test_generate_email_address
    email = mailbox.generate_email_address
    assert_includes(email, '@mailosaur.in')
  end

  def test_no_emails_found
    params = "{\"recipient\"=>\"notA@email.com\", \"key\"=>\"#{api_key}\", \"mailbox\"=>\"#{mailbox_id}\"}"
    emails = mailbox.get_emails_by_recipient("notA@email.com")
    assert_equal(emails, message_string.no_emails_found(params))
  end

  def assert_email(email)
    # html links: done

    assert_equal(3, email.html.links.length)
    assert_includes(email.html.links[0].href, 'http://mandrillapp.com')
    assert_equal('mailosaur', email.html.links[0].text)
    assert_includes(email.html.links[1].href,'http://mandrillapp.com')
    assert_equal(nil, email.html.links[1].text)
    assert_includes(email.html.links[2].href, '/invalid?')
    assert_equal(email.html.links[2].text, 'invalid')

    # html images: done
    assert(email.html.images[1].src.end_with?('.png'))
    assert_equal('Inline image 1', email.html.images[1].alt)

    # html body: done
    body = "<div dir=\"ltr\"><img src=\"https://mailosaur.com/favicon.ico\" /><div style=\"font-family:arial,sans-serif;font-size:13px;color:rgb(80,0,80)\">this is a test.</div><div style=\"font-family:arial,sans-serif;font-size:13px;color:rgb(80,0,80)\"><br>this is a link:"
    # body = body.Replace((char)32, (char)160)
    # email.html.Body = email.html.body.replace((char)32, (char)160)
    assert_includes(email.html.body, body)

    # text links: done
    assert_equal(2, email.text.links.length)
    assert_equal("https://mailosaur.com/", email.text.links[0].href)
    assert_equal("https://mailosaur.com/", email.text.links[0].text)
    assert_equal("https://mailosaur.com/", email.text.links[1].href)
    assert_equal("https://mailosaur.com/", email.text.links[1].text)

    # text body: done
    text = "this is a test.\n\nthis is a link: mailosaur <https://mailosaur.com/>\n\nthis is an image:[image: Inline image 1] <https://mailosaur.com/>\n\nthis is an invalid link: invalid\n"

    #text = text.Replace((char)32, (char)160)
    #email.text.Body = email.text.Body.Replace((char)32, (char)160)
    assert_equal(text, email.text.body)

    #headers:
    assert_equal(email.headers['received'].first.split.first, 'from')
    assert_equal('anyone <anyone@example.com>', email.headers['from'])

    assert_equal("anybody <#{recipient_address_short}>", email.headers['to'])
    # binding.pry
    refute_nil(email.headers['date'])
    assert_equal('test subject', email.headers['subject'])

    #properties:
    assert_equal('test subject', email.subject)
    assert_equal('normal', email.priority)

    assert(email.creationdate.year > 2013)
    refute_nil(email.senderHost)
    refute_nil(email.mailbox)

    #raw eml:
    refute_nil(email.rawId)
    eml = mailbox.get_raw_email(email.rawId)
    refute_nil(eml)
    assert(eml.length > 1)
    assert(eml.start_with?('Received') || eml.start_with?('Authentication'))


    #from:
    assert_equal('anyone@example.com', email.from[0].address)
    assert_equal('anyone', email.from[0].name)

    #to:
    assert_equal(recipient_address_short, email.to[0].address)
    assert_equal('anybody', email.to[0].name)

    #attachments:
    assert_equal(2, email.attachments.length, 'there should be 2 attachments')

    #attachment 1:
    attachment1 = email.attachments[0]
    refute_nil(attachment1.id)
    #assert(attachment1.Id.EndsWith(".png"))
    assert_equal(4819, attachment1.length)
    #assert_equal("logo-m.png", attachment1.FileName)

    assert_equal("image/png", attachment1.contentType)

    #var data1 = Mailbox.GetAttachment(attachment1.Id)
    #refute_nil(data1)

    #attachment 2:
    attachment2 = email.attachments[1]
    assert(attachment2.id.end_with?('logo-m-circle-sm.png'))
    assert_equal(5260, attachment2.length)
    assert_equal('logo-m-circle-sm.png', attachment2.fileName)
    assert_equal('image/png', attachment2.contentType)

    data2 = mailbox.get_attachment(attachment2.id)
    refute_nil(data2)
    assert_equal(attachment2.length, data2.length)
  end

  def send_test_email(recipient)
    puts "\n\e[36m Sending Email \e[0m"
    Mail.deliver do
      to      recipient
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

    puts "\e[32m Email Delivered \e[0m"
  end

end