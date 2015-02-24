require 'rubygems'
require 'rest_client'
require 'json'
require 'rest_client'
require 'securerandom'
require 'date'
require "#{File.dirname(__FILE__)}/mailosaur/email"

# Main class to access Mailosaur.com api.
class Mailosaur
  @MAILBOX
  @API_KEY
  @BASE_URI

  # Pass in your mailbox id and api key to authenticate
  # Leave mailbox and/or apiKey empty to load settings from environment.
  # export MAILOSAUR_APIKEY=abcex7
  # export MAILOSAUR_MAILBOX=123456abcde
  def initialize(mailbox, apiKey)
    @MAILBOX = ENV['MAILOSAUR_MAILBOX'] || mailbox
    @API_KEY = ENV['MAILOSAUR_APIKEY'] || apiKey
    @BASE_URI = 'https://mailosaur.com/v2'
  end

  # Retrieves all emails which have the searchPattern text in their body or subject.
  def getEmails(searchCriteria = Hash.new)
    if searchCriteria.is_a? String
      search = searchCriteria
      searchCriteria = Hash.new
      searchCriteria['search'] = search
    end
    searchCriteria['key'] = @API_KEY
    searchCriteria['mailbox'] = @MAILBOX
    for i in 1..10
      response = RestClient.get("#{@BASE_URI}/emails", {:params => searchCriteria})
      data = JSON.parse(response.body)
      emails = data.map { |em| Email.new(em) }

      if !emails.nil? && emails.length>0
        return emails
      end
      # back off and retry
      sleep(i*i)
    end
  end

  # Retrieves all emails sent to the given recipient.
  def getEmailsByRecipient(recipientEmail)
    searchCriteria = Hash.new
    searchCriteria['recipient']= recipientEmail
    return getEmails(searchCriteria)
  end

  # Retrieves the email with the given id.
  def getEmail(emailId)
    params = Hash.new
    params['key'] = @API_KEY
    response = RestClient.get(@BASE_URI + '/email/' + emailId, {:params => params})
    data = JSON.parse(response.body)
    email = Email.new(data)
    return email
  end

  # Deletes all emails in a mailbox.
  def deleteAllEmail
    queryParams = Hash.new
    queryParams['key'] = @API_KEY
    queryParams['mailbox'] = @MAILBOX
    RestClient.post("#{@BASE_URI}/emails/deleteall", nil, {:params => queryParams})
  end

  # Deletes the email with the given id.
  def deleteEmail(emailId)
    params = Hash.new
    params['key'] = @API_KEY
    RestClient.post(@BASE_URI + '/email/' + emailId + '/delete/', nil,{:params => params})
  end

  # Retrieves the attachment with specified id.
  def getAttachment(attachmentId)
    params = Hash.new
    params['key'] = @API_KEY
    response = RestClient.get(@BASE_URI + '/attachment/' + attachmentId, {:params => params})
    return response.body
  end

  # Retrieves the complete raw EML file for the rawId given. RawId is a property on the email object.
  def getRawEmail(rawId)
    params = Hash.new
    params['key'] = @API_KEY
    response = RestClient.get(@BASE_URI + '/raw/' + rawId, {:params => params})
    return response.body
  end

  # Generates a random email address which can be used to send emails into the mailbox.
  def generateEmailAddress()
    uuid = SecureRandom.hex(3)
    return "%s.%s@mailosaur.in" % [uuid, @MAILBOX]
  end
end
