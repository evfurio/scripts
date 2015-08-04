=begin
    d-con %QAAUTOMATION_SCRIPTS%\tutorials\advanced\email_template_http_server.rb --or
    author : dturner
    #!/usr/bin/env ruby

    Example usage:
        http://localhost:33566/ (this will show the specified error message)
        http://localhost:33566/password_change?e=email_address@gmail.com&p=password
=end
require "#{ENV['QAAUTOMATION_SCRIPTS']}/EnterpriseServices/dsl/src/dsl"
require "webrick"
require "base64"

class EmailTemplates
  def self.password_change(email, password)
    # Get email from client -- put this in a DSL
    client_gmail = GmailClient.new(email, password)
    mail_list = client_gmail.most_recent
    mail_length = mail_list.length
    if mail_length > 0
      #puts mail_list[0].subject
      #html = mail_list[0].subject
      html = mail_list[0].body.to_s.gsub(/\\r\\n +/, ' ')
      #html = mail_list[0].body

      #@html_rsp = Base64.decode64(html)
      @html_rsp = html
    else
      $tracer.trace("No mail today!")
    end
    return @html_rsp
  end

#trying to fix the issue with the email returning "=" on line breaks but also sanitizing inputs
  def quoted_string(scanner)
    return nil unless scanner.scan(/"/)
    text = ''
    while true do
      chunk = scanner.scan(/[\r\n \t\041\043-\176\200-\377]+/) # not "

      if chunk
        text << chunk
        text << scanner.get_byte if
            chunk.end_with? '\\' and '"' == scanner.peek(1)
      else
        if '"' == scanner.peek(1)
          scanner.get_byte
          break
        else
          return nil
        end
      end
    end

    text
  end
end

class EmailServlet < WEBrick::HTTPServlet::AbstractServlet
  def do_GET (request, response)
    if request.query["e"] && request.query["p"]
      email = request.query["e"]
      password = request.query["p"]
      response.status = 200
      response.content_type = "text/html"

      case request.path
        when "/password_change"
          result = EmailTemplates.password_change(email, password)
        else
          result = "No such method"
      end

      response.body = result
    else
      response.status = 200
      response.body = "You did not provide the correct parameters"
    end
  end
end

server = WEBrick::HTTPServer.new(:Port => 33566)

server.mount "/", EmailServlet

trap("INT") {
  server.shutdown
}

server.start

