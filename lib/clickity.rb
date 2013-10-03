require 'rubygems'
require 'rest_client'
require 'json'
require 'rest_client'
require 'securerandom'
require "#{File.dirname(__FILE__)}/clickity/email"

class Clickity
  @MAILBOX
  @API_KEY
  @BASE_URI

  def initialize(mailbox, apiKey)
    @MAILBOX = mailbox
    @API_KEY = apiKey
    @BASE_URI = 'https://api.clickity.io/v2'
  end

  def deleteAllEmail
    queryParams = Hash.new
    queryParams['key'] = @API_KEY
    queryParams['mailbox'] = @MAILBOX
    RestClient.post("#{@BASE_URI}/emails/deleteall", nil, {:params => queryParams})
  end

  def getEmails(searchCriteria = Hash.new)
    if searchCriteria.is_a? String
      search = searchCriteria
      searchCriteria = Hash.new
      searchCriteria['search'] = search
    end
    searchCriteria['key'] = @API_KEY
    searchCriteria['mailbox'] = @MAILBOX
    response = RestClient.get("#{@BASE_URI}/emails", {:params => searchCriteria})
    data = JSON.parse(response.body)
    emails = data.map { |em| Email.new(em) }
    return emails
  end

  def getEmailsByRecipient(recipientEmail)
    searchCriteria = Hash.new
    searchCriteria['recipient']= recipientEmail
    return getEmails(searchCriteria)
  end

  def getEmail(emailId)
    params = Hash.new
    params['key'] = @API_KEY
    response = RestClient.get(@BASE_URI + '/email/' + emailId, {:params => params})
    data = JSON.parse(response.body)
    email = Email.new(data)
    return email
  end

  def deleteEmail(emailId)
    params = Hash.new
    params['key'] = @API_KEY
    RestClient.post(@BASE_URI + '/email/' + emailId + '/delete/', nil,{:params => params})
  end


  def getAttachment(attachmentId)
    params = Hash.new
    params['key'] = @API_KEY
    response = RestClient.get(@BASE_URI + '/attachment/' + attachmentId, {:params => params})
    return response.body
  end


  def getRawEmail(rawId)
    params = Hash.new
    params['key'] = @API_KEY
    response = RestClient.get('https://api.clickity.io/v1/attachments/' + rawId, {:params => params})
    return response.body
  end

  def generateEmailAddress()
    uuid = SecureRandom.hex(3)
    return "%s.%s@clickity.me" % [uuid, @MAILBOX]
  end
end
