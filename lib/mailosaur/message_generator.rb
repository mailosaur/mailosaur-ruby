class MessageGenerator
  attr_accessor :message

  def no_emails_found(data)
    "\e[36m No emails were found for #{data} \e[0m\n\e[32m Try checking the params. \e[0m"
  end

  def new_syntax(method)
    puts ":::::: Please use new syntax for #{method} ::::::\n
          \e[36m @mailbox.#{look_ruby(method)}(params) \e[0m"
  end

  def sleep
    puts "\e[36m Let's give the email some time to get there... \e[0m"
  end

  private

  def look_ruby(method)
    output = String.new
    caps   = method.scan(/[A-Z]+/).map(&:downcase!)
    other  = method.split(/[A-Z]+/)
    a3 = other.join('_ ')
    a4 = a3.split(' ')
    words = ''
    other.count.times do |i|
      words << "#{a4[i]}#{caps[i]}"
    end
    words
  end
end