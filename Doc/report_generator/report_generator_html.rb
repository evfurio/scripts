#Usage
# d-con .\report_generator_html.rb --csv .\report_config.csv --range 480_nightly --or

require 'timeout'
require 'enumerator'
require 'ostruct'
require 'ntlm/smtp'
require 'base64'
require 'etc'
require 'dbi'
require 'erb'
require 'java'
require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"

class GSReportBuilder

#reads a file and makes it a string
  def parse_file_template(filename)
    file = ''
    if File.file?(filename.gsub!(/\\/, "/"))
      expanded_filename = File.realdirpath(filename)
      begin
        file = File.read(expanded_filename)
      rescue Exception => ex
        raise ToolException.new(ex, "unable to parse HTML file, cannot read '#{expanded_filename}': #{ex.message}")
      end
    else
      raise Exception, "unable to parse HTML file: unable to locate '#{filename}'"
    end
    return file
  end

#binds the parameters to the template which is returned from parse_file_template
  def populate_html_template(html, status, table_results)
    #####TODO: put in data set
    @failed = status[1]
    @passed = status[3]
    @table_results = table_results.split().join.strip
    html_template = parse_file_template(html)
    html_src = ERB.new(html_template).result(binding)
  end

  def populate_sql_template(sql)
    @hours = -24
    @lab_machines = "'dl1gsqlt03','dl1gsqlt04','dl1gsqlt05'"
    @user_names = 's_tfstest'

    sql_template = parse_file_template(sql)
    sql_src = ERB.new(sql_template).result(binding)
    return sql_src
  end

  def db_exec(sql)
    server = 'gv1hqqdb11.testgs.pvt'
    database = 'PAL'
    db = DbManager.new(server, database)
    results = db.exec_sql(sql)
    return results
  end

  def create_html_table(results)
    table_array = []
    results.each_with_index { |y| table_array << "<tr><td>#{convert_type(y.failure_description)}</td>
    <td>#{y.total}</td></tr>" }

    return table_array
  end

  def convert_type(v)
     v.getSubString(1, v.length)
  end

  def send_report(send_to, html)
    t = Time.now
    time_stamp = t.strftime("%FT%T.0000000-06:00")
    time = t.strftime("%T")
    date = t.strftime("%F")
    #html_body, sql_results = builder
    sql_template = 'C:\\dev\\QAAutomationScripts\\Doc\\report_queries\\get_run_report.sql'
    sql = populate_sql_template(sql_template)
    sql_results = db_exec(sql)
    sql_failures = 'C:\\dev\\QAAutomationScripts\\Doc\\report_queries\\lab_top_failure.sql'
    sql2 = populate_sql_template(sql_failures)
    top_failures = db_exec(sql2)
    table_results = create_html_table(top_failures)
    status = []
    sql_results.each_with_index { |x| status << x.status
    status << x.total }
    html_body = populate_html_template(html, status, table_results)
    smtp_server = "gsmail.babgsetc.pvt"
    msg_body =<<-EOF

    <BODY>
    EOF

    msg_no_attachment = <<-EOF.gsub /(^ +| +$)/, ""
    From: <FROM_ADDRESS>
    To: <TO_ADDRESS_TITLE>
    Subject: <SUBJECT>
    Content-Type: <TYPE>
    #{msg_body}
    EOF


    from_address = "QA AutoBot Reporter"
    subject = "Nightly Automation Run Results for #{date}"
    body = html_body
    to_title = "#{Etc.getlogin} #{Time.now}"
    marker = 'bdfd61ef-275a-4345-a279-8f1d1ca2e81a'
    from_address =~ /.*<(.*)>/
    content_type = "#{'text/html'}"
    from_address_part = $1
    header = msg_no_attachment
    header.sub!('<FROM_ADDRESS>', from_address)
    header.sub!('<TO_ADDRESS_TITLE>', to_title)
    header.sub!('<SUBJECT>', subject)
    header.sub!('<TYPE>', content_type)
    mail_content = msg_no_attachment.sub!('<BODY>', body)
    smtp_conn = Net::SMTP.new(smtp_server).start

    send_to.each { |v|
      smtp_conn.send_mail(mail_content, from_address_part, v.to_s)
    }
  end


end

send_to = ['davidturner@gamestop.com', 'larryhenderson@gamestop.com']
reporter = GSReportBuilder.new
reporter.send_report(send_to, html = 'C:\\dev\\QAAutomationScripts\\Doc\\report_html\\test.html')