# Mailosaur Ruby bindings

Mailosaur allows you to automate tests that require email. You can also use it for manual testing as it gives you unlimited test email addresses or use it as a fake/dummy SMTP service.

For more info go to [mailosaur.com](https://mailosaur.com/)


## Installation

  ``` gem install mailosaur ```

## Usage
```ruby
require 'mailosaur'

mailbox = Mailosaur.new(mailbox,apikey)

emails = mailbox.get_emails_by_recipient('anything.1eaaeef6@mailosaur.in')
```

Optional: Timeout

- Default timeout is set to 20, if you want to increase of decrease this, set the time in seconds to the `MAILOSAUR_TIMEOUT` variable.

``` export MAILOSAUR_TIMEOUT=60 ```


##Api

*functions:*

- get_emails - Retrieves all emails

- get_emails('search_text') - Retrieves all emails with ``` search_text ``` in their body or subject.

- get_emails_by_recipient('recipient_email') -
Retrieves all emails sent to the given recipient.

- get_email('email_id') -
Retrieves the email with the given id.

- delete_all_emails -
Deletes all emails in a mailbox.

- delete_email('email_id') -
Deletes the email with the given id.

- get_attachment('attachment_id') -
Retrieves the attachment with specified id.

- get_raw_email('raw_id') -
Retrieves the complete raw EML file for the rawId given. RawId is a property on the email object.

- generate_email_address -
Generates a random email address which can be used to send emails into the mailbox.

*Email Object Structure*

- **Email** - The core object returned by the Mailosaur API
  - **id** - The email identifier
  - **creationdate** - The date your email was received by Mailosaur
  - **senderHost** - The host name of the machine that sent the email
  - **rawId** - Reference for raw email data
  - **html** - The HTML content of the email
    - **links** - All links found within the HTML content of the email
    - **images** - All images found within the HTML content of the email
    - **body** - Unescaped HTML body of the email
  - **text** - The text content of the email
    - **links** - All links found within the text content of the email
    - **body** - Text body of the email
  - **headers** - Contains all email headers as object properties
  - **subject** - Email subject
  - **priority** - Email priority
  - **from** - Details of email sender(s)
    - **address** - Email address
    - **name** - Email sender name
  - **to** - Details of email recipient(s)
    - **address** - Email address
    - **name** - Email recipient name
  - **attachments** - Details of any attachments found within the email
    - **id** - Attachment identifier
    - **fileName** - Attachment file name
    - **length** - Attachment file size (in bytes)
    - **contentType** - Attachment mime type (e.g. "image/png")
