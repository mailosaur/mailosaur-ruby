require File.expand_path('../../lib/MailboxApi', __FILE__)
require File.expand_path('../smtp', __FILE__)


mailboxId = '729375a7'
password = '967740d6'
apikey = 'f4c748f95bd739c'
client = MailboxApi.new(mailboxId,apikey)


# empty mailbox so we start in a clean state:
client.deleteAllEmail

# generate a random email address for our mailbox:
address = client.generateEmailAddress

# send an email to above address:
smtpclient = SmtpClient.new(mailboxId, password)
smtpclient.sendEmail(address, 'this is the subject', 'plain text email with link to https://github.com/clickityapp/clickity-ruby')

# retrieve all emails:
emails = client.getEmails()

# print out their subject  (there should only be one)
emails.each do |email|
  p email.id
end

# retrieve email by id:
email = client.getEmail(emails[0].id)
p email.id

# retrieve email by the unique email address we generated:
email = client.getEmailsByRecipient(address)[0]
p email.id

# print out the github html page:
p email.text.links[0].content

# retrieve the raw .eml file
p client.getRawEmail(email.rawId)

# delete the email:
client.deleteEmail(email.id)

