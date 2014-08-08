require "#{File.dirname(__FILE__)}/email_address"
require "#{File.dirname(__FILE__)}/email_data"
require "#{File.dirname(__FILE__)}/attachment"

class Email
  attr_accessor :id, :creationdate, :senderHost, :from, :to, :mailbox, :rawId, :html, :text, :headers, :subject, :priority, :attachments

  def initialize(hash)
    @id = hash['id']
    @creationdate = DateTime.iso8601(hash['creationdate'])
    @senderHost = hash['senderHost']
    @from= hash['from'].map { |f| EmailAddress.new(f) }
    @to= hash['to'].map { |t| EmailAddress.new(t) }
    @mailbox = hash['mailbox']
    @rawId = hash['rawId']
    @html = hash.has_key?('html')?EmailData.new(hash['html']):nil
    @text = hash.has_key?('text')?EmailData.new(hash['text']):nil
    @headers = hash['headers']
    @subject = hash['subject']
    @priority = hash['priority']
    @attachments = hash.has_key?('attachments')?hash['attachments'].map { |a| Attachment.new(a) } : nil
  end
end