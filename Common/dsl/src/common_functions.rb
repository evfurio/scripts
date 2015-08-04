# This file contains the domain specific language (DSL) methods for interacting
# with the GameStop website, Services and related products
# Author:: DTurner
# Copyright:: Copyright (c) 2013 GameStop, Inc.
# Not for external distribution.

require 'timeout'
require 'enumerator'
require 'ostruct'
require 'ntlm/smtp'
require 'base64'
require 'etc'

module CommonFunctions

  def generate_new_user_credentials(prefix, domain)
    this = [('a'..'z'), ('A'..'Z'), (1..5)].map { |i| i.to_a }.flatten
    idnew = (0...5).map { this[rand(this.length)] }.join
    return "#{prefix}#{idnew}@#{domain}"
  end

  # @return [Object]
  def refresh_page
    $tracer.trace("CommonFunctions: #{__method__}, Line #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    instance_variable_get(:@driver).navigate.refresh
    $tracer.trace("Web Browser Page Has Been Refreshed")
  end

  # Clears the temporary internet files for designated browser
  def delete_internet_files(browser_type)
    $tracer.trace("CommonFunctions: #{__method__}, Line #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    WebBrowser.delete_temporary_internet_files(browser_type)
  end

  # Converting ASCII-8BIT to UTF-8 based domain-specific guesses
  def convert_to_utf8(value)
    $tracer.trace("CommonFunctions: #{__method__}, Line #{__LINE__}")
    if value.is_a? String
      begin
        # Try it as UTF-8 directly
        cleaned = value.dup.force_encoding('UTF-8')
        unless cleaned.valid_encoding?
          # Some of it might be old Windows code page
          cleaned = value.encode( 'UTF-8', 'Windows-1252' )
        end
        value = cleaned
      rescue EncodingError
        # Force it to UTF-8, throwing out invalid bits
        value.encode!( 'UTF-8', invalid: :replace, undef: :replace )
      end
    end
  end

  # Retries while the negative conditional is not met or until timeout occurs.  Sleeps +1 second per retry.
  # @browser.retry_until_found(lambda{@browser.order_confirmation_label.exists != false})
  def retry_until_found(negative_conditional, timeout_seconds = 30, sleep_seconds = 1, browser_timeout_seconds = nil)
    orig_timeout = nil
    unless browser_timeout_seconds.nil?
      orig_timeout = SeleniumBrowser.class_variable_get(:@@default_timeout)
      SeleniumBrowser.default_timeout((browser_timeout_seconds * 1000))
    end

    begin
      status = Timeout::timeout(timeout_seconds) {
        while (Thread.new { negative_conditional.call }.value) do
          sleep sleep_seconds
        end
      }
    rescue Timeout::Error
    ensure
      yield if block_given?
      unless orig_timeout.nil?
        SeleniumBrowser.default_timeout(orig_timeout)
      end
    end
  end

  # Gets current page URL
  def return_current_url
    $tracer.trace("CommonFunctions: #{__method__}, Line #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    $tracer.trace("Current URL: #{get_url_data(self).full_url}")
    $tracer.report("Current URL: #{get_url_data(self).full_url}")
  end
  
  # Generates a random value based on input
  # === Parameters:
  # _input_:: user specified value
  def random_value(input)
    $tracer.trace("CommonFunctions: #{__method__}, Line #{__LINE__}")
    input[Kernel.rand(input.size)]
  end

  #ex is the block to be evaluated
  #should be used for retry logic that is by number of retries not timeout
  def retry_on_exception(ex, n = 1, &block)
    $tracer.trace("CommonFunctions: #{__method__}, Line #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    begin
      count = 1
      block.call
    rescue ex
      if count <= n
        count += 1
        retry
      else
        raise
      end
    end
  end


  def ping(user, host, &block)
    $tracer.trace("CommonFunctions: #{__method__}, Line #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    begin
      ping_output = []
      timeout(20) do
        ping_output = IO.popen("ssh #{user}@#{host} 'echo \"pong\"'", "w+")
      end
      ping = ping_output.readlines.join[/pong/] ? true : false
    rescue Timeout::Error
      ping = false
    rescue
      ping = false
    end
    ping_output.close
    if block_given? && ping
      yield
    end
    return ping
  end

  public
  # Converts an array of string values to instance variables as empty arrays
  # the method get_product_from_query is currently utilizing this functionality
  # @param [Object] arr
  def set_instance_variables(arr)
    $tracer.trace("CommonFunctions: #{__method__}, Line #{__LINE__}")
    arr.each { |i| instance_variable_set("@#{i}", []) }
  end


  # @return [Object]
  # TODO : We may need to evaluate this to be in a different location as it isn't necessarily a common function... open to debate.
  def get_product_from_query(results_from_file, catalog_svc, catalog_svc_version, params, session_id)
    $tracer.trace("CommonFunctions: #{__method__}, Line #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    #Product details pages are a royal pain in the ass to test.
    # Need a better way to define all the product attributes that we need to test and dynamically pull them in and assign their appropriate variables
    product_attributes = %w(product_urls list_price additional_handling_fee availability availability_message average_overall_rating cannot_cancel_order condition definition_notes developer publisher display_name esrb_rating esrb_rating_text esrb_img is_bill_ship_match is_online_only is_in_store_pickup_for_hops is_in_store_pickup_pre_order recommendations_id sku_id platform_count platform review_count product_type)
    matured_product = false
    physical_product = false
    set_instance_variables(product_attributes)
    @product_urls = []
    #catalog_get_product_data = get_products_rsp.http_body.find_tag("product").at(0)
		number_of_products = results_from_file.length
		while @product_urls.length < number_of_products
      results_from_file.each do |sku|
				product_sku = params['sku'] == "" ? sku.variantid : sku
				resp = catalog_svc.perform_get_product_by_sku(catalog_svc_version, session_id, product_sku)
        product_details = resp.http_body.find_tag("product")
        @product_urls << product_details.url.content
        @list_price << product_details.list_price.content
        @additional_handling_fee << product_details.additional_handling_fee.content
        @availability << product_details.availability.content
        @availability_message << product_details.availability_message.content
        @average_overall_rating << product_details.average_overall_rating.content
        @cannot_cancel_order << product_details.cannot_cancel_order.content
        @condition << product_details.condition.content
        #@definition_notes << product_details.definition_notes.content
        @developer << product_details.developer.content
				@publisher << product_details.publisher.content
        @display_name << product_details.display_name.content
        @esrb_rating << product_details.esrb_rating.content
        @esrb_rating_text << product_details.esrb_rating_text.content
				@esrb_img << product_details.esrb_small_image_url.content
        @is_bill_ship_match << product_details.is_billing_and_shipping_match.content
        @is_online_only << product_details.is_online_only.content
        @is_in_store_pickup_for_hops << product_details.is_in_store_pickup_for_hops.content
        @is_in_store_pickup_pre_order << product_details.is_in_store_pickup_pre_order.content
        @recommendations_id << product_details.recommendations_id.content
        @sku_id << product_details.sku.content
				@platform_count << product_details.platforms.string.length
				@platform << product_details.platforms.string[0].content
				@review_count << product_details.total_review_count.content
				@product_type << product_details.product_type.content
        matured_product = (product_details.esrbrating.eql?("M") ? true : false) if !matured_product
        physical_product = (product_details.condition.eql?("Digital") ? false : true) if !physical_product
      end
    end
    prod_attr = [@product_urls, @list_price, @additional_handling_fee, @availability, @availability_message, @average_overall_rating, @cannot_cancel_order, @condition, @definition_notes, @developer, @publisher, @display_name, @esrb_rating, @esrb_rating_text, @esrb_img, @is_bill_ship_match, @is_online_only, @is_in_store_pickup_for_hops, @is_in_store_pickup_pre_order, @recommendations_id, @sku_id, @platform_count, @platform, @review_count, @product_type]

    @hash_array = {}
    product_attributes.each_with_index do |value, index|
			puts "----------- #{index} #{value}:  #{prod_attr[index]}"
			@hash_array[value] = prod_attr[index]
    end
		
    $tracer.report(@hash_array)
    return @sku_id, prod_attr, @hash_array
  end

  def generate_credit_card_svc(cctype)
    $tracer.trace("GameStopPurchaseOrderServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    cc_info = []

    @named = {
        :mastercard => {:prefixes => ['510040', '512000', '522182', '532561', '546604', '553823', '560054'], :size => 16},
        :visa => {:prefixes => ['409311', '410897', '412134', '415874', '411773'], :size => 16},
        :amex => {:prefixes => ['34', '377481', '372888', '3764'], :size => 15},
        :discover => {:prefixes => ['6011'], :size => 16}
    }

    begin
      if cctype.downcase == "generate"
        cc_type = ['Visa', 'Discover', 'AmericanExpress', 'MasterCard']
        cctype_rnd = cc_type.sample
      else
        cctype_rnd = cctype
      end
    rescue Exception => ex
      "Credit Card must be set to 'generate' to generate a new credit card"
    end

    @exp_month = Random.new.rand(1..12)
    @exp_year = Random.new.rand(2016..2032)

    if cctype_rnd == "AmericanExpress"
      card_types = "amex"
    else
      card_types = "#{cctype_rnd}"
    end

    @cc_number = CreditCard.method_missing("#{card_types.downcase}", @named)

    (card_types == "amex") ? @cvv = Random.new.rand(1000..9999) : @cvv = Random.new.rand(100..999)

    cc_info.push(:cnum, @cc_number, :ctype, cctype_rnd, :expmnth, @exp_month, :expyr, @exp_year, :cvv, @cvv)
    cc = Hash[*cc_info]
    is_valid_cc = CreditCard.valid?(cc[:cnum])
    is_valid_cc.should == true
    return cc
  end


  def generate_credit_card(cctype)
    $tracer.trace("CommonFunctions: #{__method__}, Line #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    cc_info = []
    @named = {}
    begin
      if cctype.downcase == "generate"
        cc_type = ['Visa', 'Discover', 'American Express', 'MasterCard']
        cctype_rnd = cc_type.sample
      else
        cctype_rnd = cctype
      end
    rescue Exception => ex
      "Credit Card must be set to 'generate' to generate a new credit card"
    end

    @exp_month = %w(01 02 03 04 05 06 07 08 09 10 11 12).sample
    @exp_year = Random.new.rand(2016..2033).to_s

    if cctype_rnd == "American Express"
      card_types = "amex"
    else
      card_types = "#{cctype_rnd}"
    end

    @cc_number = CreditCard.method_missing("#{card_types.downcase}", @named)

    (card_types == "amex") ? @cvv = Random.new.rand(1000..9999).to_s : @cvv = Random.new.rand(100..999).to_s

    cc_info.push(:cnum, @cc_number, :ctype, cctype_rnd, :expmnth, @exp_month, :expyr, @exp_year, :cvv, @cvv)
    cc = Hash[*cc_info]
    is_valid_cc = CreditCard.valid?(cc[:cnum])
    is_valid_cc.should == true
    return cc
  end

  def verify_user(content, user_key)
    $tracer.trace("CommonFunctions: #{__method__}, Line #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    keymaster = AES.decrypt(content, {iv: user_key})[:content]
    gatekeeper = Etc.getlogin
      if gatekeeper == keymaster
        return true
      else
        warn "You are not authorized to access the SMTP Mail server".upcase
        return false
      end
  end


  def get_gmail_list(user, password)
    $tracer.trace("CommonFunctions: #{__method__}, Line #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    @client_gmail = GmailClient.new(user, password)
    mail_list = @client_gmail.most_recent
    mail_length = mail_list.length
    if mail_length > 0
      subject = mail_list[0].subject
      body = mail_list[0].body
      $tracer.trace(body)
      $tracer.report("Script accessed email from mail server : #{Time.now}")
    else
      return false, false
    end

    return subject, body
  end

  #Only use this method for testing email validation
  def send_test_email(send_to)
    $tracer.trace("CommonFunctions: #{__method__}, Line #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    user_key = "UKwsLuPG0xcmNeL+1EZYHA=="
    content = "Z+yyOOgeBT3EQhxYgbAK8Q=="

    # IF this method is being used for testing, please let davidturner@gamestop.com know for a user key.
    @smtp_server = ($options.smtp_server)

    @msg_body =<<-EOF.gsub /(^ +| +$)/, ""

    <BODY>
    EOF

    @msg_no_attachment = <<-EOF.gsub /(^ +| +$)/, ""
    From: <FROM_ADDRESS>
    To: <TO_ADDRESS_TITLE>
    Subject: <SUBJECT>
    #{@msg_body}
    EOF

    @from_address = "AutoBot Alerter"
    @subject = "This is a subject test"
    @body = <<EOF
    <h1>This is a body test</h1>
EOF
    @to_addresses = send_to
    @to_title = "#{Etc.getlogin} #{Time.now}"
    @marker = generate_guid
    @from_address =~ /.*<(.*)>/
    @content_type = "#{'text/html'}"
    from_address_part = $1
    header = @msg_no_attachment
    header.sub!('<FROM_ADDRESS>', @from_address)
    header.sub!('<TO_ADDRESS_TITLE>', @to_title)
    header.sub!('<SUBJECT>', @subject)
    header.sub!('<TYPE>', @content_type)
    mail_content = header +  @msg_no_attachment.sub!('<BODY>', @body)
    @smtp_conn = Net::SMTP.new(@smtp_server).start
    verified = verify_user(content, user_key)
    $tracer.trace("User verified? #{verified}")
    if verified == true
      @smtp_conn.send_mail(mail_content, from_address_part, @to_addresses)
      $tracer.report("Approx Time Sent to Email Server : #{Time.now}")
    end
  end

  def connect_to_nightly_run_local_data
    path = "//dl1gsqlt02.testecom.pvt/Users/Public/d_con_data/"
    db_path = "#{path}"
    log_path = "#{path}sqlite3_database"
    self.create_file(log_path, ".log")

    ActiveRecord::Base.logger = Logger.new(File.open(log_path, 'a'))
    ActiveRecord::Base.establish_connection(
        :adapter => 'jdbcsqlite3',
        #:database => "#{ENV['PUBLIC']}/d_con_data/nightly_run_data.db"
        :database => "#{db_path}nightly_run_data.db"
    )
  end

  def create_file(path, extension)
    dir = File.dirname(path)

    unless File.directory?(dir)
      FileUtils.mkdir_p(dir)
    end

    path << ".#{extension}"
    File.new(path, 'w')
  end

end