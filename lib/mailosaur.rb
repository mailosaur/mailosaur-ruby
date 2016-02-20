require_relative 'helper.rb'

class Mailosaur
  attr_reader :message

  def initialize(mailbox, apiKey)
    @mailbox  = ENV['MAILOSAUR_MAILBOX'] || mailbox
    @api_key  = ENV['MAILOSAUR_APIKEY']  || apiKey
    @base_uri = 'https://mailosaur.com/v2'
    @message  = MessageGenerator.new
  end

  # Retrieves all emails which have the searchPattern text in their body or subject.
  def get_emails(search_criteria = {})
    if search_criteria.is_a? String
      search_criteria = {'search' => search_criteria}
    end
    search_criteria['key']     = @api_key
    search_criteria['mailbox'] = @mailbox
    response = send_get_emails_request(search_criteria)
    if response.length > 2
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
    response = RestClient.get("#{@base_uri}/email/#{email_id}", {:params => params})
    data     = JSON.parse(response.body)
    Email.new(data)
  end

  # Deletes all emails in a @mailbox.
  def delete_all_emails
    binding.pry
    query_params = {'key' => @api_key, '@mailbox' => @mailbox }
    RestClient.post("#{@base_uri}/emails/deleteall", nil, {:params => query_params})
  end

  # Deletes the email with the given id.
  def delete_email(email_id)
    params = {'key' => @api_key}
    RestClient.post("#{@base_uri}/email/#{email_id}/delete/", nil,{:params => params})
  end

  # Retrieves the attachment with specified id.
  def get_attachment(attachment_id)
    params = {'key' => @api_key}
    RestClient.get("#{@base_uri}/attachment/#{attachment_id}", {:params => params}).body
  end

  # Retrieves the complete raw EML file for the rawId given. RawId is a property on the email object.
  def get_raw_email(raw_id)
    params = {'key' => @api_key}
    RestClient.get("#{@base_uri}/raw/#{raw_id}", {:params => params}).body
  end

  # Generates a random email address which can be used to send emails into the @mailbox.
  def generate_email_address
    uuid = SecureRandom.hex(3)
    "%s.%s@mailosaur.in" % [uuid, @mailbox]
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
    r = ''
    begin
      Timeout::timeout(20) {
        until r.length > 2 && !r.nil?
          r = RestClient.get("#{@base_uri}/emails", {:params => search_criteria})
        end
        r
      }
    rescue Timeout::Error
      ''
    end
  end
end