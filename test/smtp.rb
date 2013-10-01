require 'net/smtp'

class SmtpClient
  attr_accessor :username, :password
  SERVER = 'clickity.io'
  FROMADDR = 'test@clickity.io'

  def initialize(username, password)
    @username = username
    @password = password
  end


  def sendEmail(to, subject, text)

    message = "From: #{FROMADDR}
To: #{to}
Subject: #{subject}

    #{text}"

    smtp = Net::SMTP.new SERVER, 25
    smtp.enable_starttls()
    smtp.start(SERVER, @username, @password, :login) do
      smtp.send_message(message, FROMADDR, to)
    end
    # sleep to ensure email is delivered
    sleep(1)
  end

end