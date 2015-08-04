# d-con %QAAUTOMATION_SCRIPTS%\GameStop\spec\Sandbox\tests\purcc_email_template_spec.rb
require 'webrick/httpproxy'
require "#{ENV['QAAUTOMATION_SCRIPTS']}/EnterpriseServices/dsl/src/dsl"

include WEBrick

$tracer.mode=:on
$tracer.echo=:on

describe "Email Template Validation" do

  it "should validate purcc template" do

    # Object Recognition "Finders"
    text1 = "Your GameStop Password Change Request"
    cid_link = "http://www.gamestop.com?cid=eml_10001453"
    logo_img = "http://www.gamestop.com/common/gui/email_header_logo.gif"
    success_text = "You have successfully created a new password for your GameStop.com account.  To ensure that your information remains secure, we notify you when your password has changed.  Should you need to contact us for any reason or you did not recently change your password, please call our customer support team at 1-800-883-8895 or email "
    email = "IS7629_61705@is.instantservice.com"


    $browser = WebBrowser.new("chrome")
    $browser.open("file:///#{ENV['QAAUTOMATION_SCRIPTS']}//EnterpriseServices//spec//UAS Password Change GS US.htm")
    

    #email_from_email.should == "GameStop Customer Care"

    Thread.new{
      config = {}
      config.update(:Port => 21599)
      config.update(:RequestCallback => Proc.new{|req,res|
        puts req.request_line,
             req.raw_header,
             res.body})
      @sinus = HTTPProxyServer.new(config)
      #@sinus.mount '/', WEBrick::HTTPServlet::AbstractServlet, './'
      @sinus.mount '/', GetEmail
      trap('INT') { @sinus.shutdown }
      @sinus.start
    }

    path = ERB.new(password_change_template(email)).result(binding)
    path = File.join("#{ENV['QAAUTOMATION_SCRIPTS']}//EnterpriseServices//spec//", "spec.html")
    puts path
    $browser.open("http://localhost:21599/")
    sleep 60
    $browser.close

    @sinus.shutdown
  end

  def password_change_template(email)
    %{<center>
    <table width="620" border="0" style= "border-collapse:collapse;">
      <tr >
        <td width="447" valign="bottom" style= "border-bottom: 2px solid;"><span style="font-family:Arial, Helvetica;font-size:24px;color:#363636;">Your GameStop Password Change Request</span></td>
        <td width="163" valign="bottom" style= "border-bottom: 2px solid;"><div align="right"><a href="http://www.gamestop.com?cid=eml_10001453/"><img src="http://www.gamestop.com/common/gui/email_header_logo.gif" width="163" height="40" border="0"></a></div></td>
      </tr>

    <tr>
    <td colspan="2" style=" padding-top: 30px; padding-bottom: 60px; font-family:Arial,
    Helvetica;font-size:12px;color:#5c5c5c; line-height: 1.4em">You have successfully created a new password for your GameStop.com account.  To ensure that your information remains secure, we notify you when your password has changed.  Should you need to contact us for any reason or you did not recently change your password, please call our customer support team at 1-800-883-8895 or email <a href="mailto:#{email}" style="font-family:Arial,
    Helvetica;  font-size:12px; color:#F00;">GameStop Customer Care</a>. <br /><br />

    Remember that GameStop will never email you asking you for your password or credit card information.<br /><br />

    Thanks for helping us maintain the security of your account.<br/><br/>

        The Gamestop Support Team<br />
      </td>
    </tr>
      <tr>
        <td colspan="2" style="border-top: 2px solid; padding-top: 10px; font-family:Arial,
        Helvetica;font-size:12px;color:#5c5c5c;"><center>GameStop | 625 Westport Parkway | Grapevine, TX | 76051</center></td>
      </tr>
    <tr>
    <td width=163><A href="http://www.gamestop.com/wistrade?cid=eml_10001453"><IMG border=0 src="http://www.gamestop.com/gs/images/wbanner/wemail_footer_trade.jpg"></A></td>
    </tr>
    </table>
    </center>
    }
  end

end

class GetEmail < WEBrick::HTTPServlet::AbstractServlet

  def do_GET(req, res)
    super
    res['ETag']          = nil
    res['Last-Modified'] = Time.now + 100**4
    res['Cache-Control'] = 'no-store, no-cache, must-revalidate, post-check=0, pre-check=0'
    res['Pragma']        = 'no-cache'
    res['Expires']       = Time.now - 100**4

    status, content_type, body = email_params(req)
    res['Content-Type'] = content_type
    res.body = body
  end

  def email_params(req)
    # Get email from client -- put this in a DSL
    client_gmail = GmailClient.new("gsautoskynet@gmail.com", "6abF129056")
    mail_list = client_gmail.most_recent
    mail_length = mail_list.length
    if mail_length > 0
      #puts mail_list[0].subject
      html = "<html>"
      html += mail_list[0].body
      html += "</html>"
      $tracer.trace(email_body.inspect)
      $tracer.trace(mail_list.inspect)
    else
      $tracer.trace("No mail today!")
    end

    return 200, "text/html", html
  end

end