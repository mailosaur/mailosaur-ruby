require "#{File.dirname(__FILE__)}/email_address"
require "#{File.dirname(__FILE__)}/email_data"
require "#{File.dirname(__FILE__)}/attachment"

class Email
  attr_accessor :id, :creationdate, :senderhost, :from, :to, :mailbox, :rawid, :html, :text, :headers, :subject, :priority, :attachments

  def initialize(hash)
    @id = hash['id']
    @creationdate = DateTime.iso8601(hash['creationdate'])
    @senderhost = hash['senderhost'] || hash['senderHost']
    @from= hash['from'].map { |f| EmailAddress.new(f) }
    @to= hash['to'].map { |t| EmailAddress.new(t) }
    @mailbox = hash['mailbox']
    @rawid = hash['rawId'] || hash['rawid']
    @html = hash.has_key?('html')?EmailData.new(hash['html']):nil
    @text = hash.has_key?('text')?EmailData.new(hash['text']):nil
    @headers = hash['headers']
    @subject = hash['subject']
    @priority = hash['priority']
    @attachments = hash.has_key?('attachments')?hash['attachments'].map { |a| Attachment.new(a) } : nil
  end
end