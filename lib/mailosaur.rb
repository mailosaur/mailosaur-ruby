require_relative 'helper.rb'


class Mailosaur
  attr_reader :message

  def initialize(mailbox = nil, apiKey = nil, base_url = nil, smtp_host = nil)
    @mailbox  = ENV['MAILOSAUR_MAILBOX'] || mailbox
    @api_key  = ENV['MAILOSAUR_APIKEY']  || apiKey
    @base_url = base_url || ENV['MAILOSAUR_BASE_URL'] || 'https://mailosaur.com/api'
    @smtp_host =  smtp_host || ENV['MAILOSAUR_SMTP_HOST'] || 'mailosaur.in'
    @message  = MessageGenerator.new
  end

  # Retrieves all emails which have the searchPattern text in their body or subject.
  def get_emails(search_criteria = {})
    if search_criteria.is_a? String
      search_criteria = {'search' => search_criteria}
    end
    search_criteria['key']     = @api_key
    response = send_get_emails_request(search_criteria)
    if !response.nil? && response.length > 2
      data   = JSON.parse(response.body)
      data.map { |em| Email.new(em) }
    else
      message.no_emails_found(search_criteria)
    end
  end

  # Retrieves all emails sent to the given recipient.
  def get_emails_by_recipient(recipient_email)
    search_criteria = {'recipient' => recipient_email}
    get_emails(search_criteria)
  end

  # Retrieves the email with the given id.
  def get_email(email_id)
    params   = {'key' => @api_key}
    response = RestClient.get("#{@base_url}/emails/#{email_id}", {:params => params})
    data     = JSON.parse(response.body)
    Email.new(data)
  end

  # Deletes all emails in a @mailbox.
  def delete_all_emails
    query_params = {'key' => @api_key }
    RestClient.post("#{@base_url}/mailboxes/#{@mailbox}/empty", nil, {:params => query_params})
  end

  # Deletes the email with the given id.
  def delete_email(email_id)
    params = {'key' => @api_key}
    RestClient.post("#{@base_url}/emails/#{email_id}/delete", nil, {:params => params})
  end

  # Retrieves the attachment with specified id.
  def get_attachment(attachment_id)
    params = {'key' => @api_key}
    RestClient.get("#{@base_url}/attachments/#{attachment_id}", {:params => params}).body
  end

  # Retrieves the complete raw EML file for the rawId given. RawId is a property on the email object.
  def get_raw_email(raw_id)
    params = {'key' => @api_key}
    RestClient.get("#{@base_url}/raw/#{raw_id}", {:params => params}).body
  end

  # Generates a random email address which can be used to send emails into the @mailbox.
  def generate_email_address
    uuid = SecureRandom.hex(3)
    "%s.%s@%s" % [uuid, @mailbox, @smtp_host]
  end

  # old methods
  def getEmails(search_criteria = {})
    message.new_syntax('getEmails')
    get_emails(search_criteria)
  end
  def getEmailsByRecipient(recipient_email)
    message.new_syntax('getEmailsByRecipient')
    get_emails_by_recipient(recipient_email)
  end
  def getEmail(email_id)
    message.new_syntax('getEmail')
    get_email(email_id)
  end
  def deleteAllEmail
    message.new_syntax('deleteAllEmail')
    delete_all_emails
  end
  def deleteEmail(email_id)
    message.new_syntax('deleteEmail')
    delete_email(email_id)
  end
  def getAttachment(attachment_id)
    message.new_syntax('getAttachment')
    get_attachment(attachment_id)
  end
  def getRawEmail(raw_id)
    message.new_syntax('getRawEmail')
    get_raw_email(raw_id)
  end
  def generateEmailAddress
    message.new_syntax('generateEmailAddress')
    generate_email_address
  end

  private

  def send_get_emails_request(search_criteria)
    RestClient.get("#{@base_url}/mailboxes/#{@mailbox}/emails", {:params => search_criteria})
  end
end
