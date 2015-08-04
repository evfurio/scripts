#Author### - mkrupin
# 03/01/2013
# 
# USAGE NOTES

# Checkout as a new user.
# d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\new_user_checkout_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range TFS48609  --browser chrome  --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"
require "bigdecimal"

$tracer.mode=:on
$tracer.echo=:on
#global_functions passes the csv row object and return the parameters.
$global_functions = GlobalFunctions.new()

$tc_desc = $global_functions.desc
$tc_id = $global_functions.id

describe "Check out new user test" do
  before(:all) do
    @browser = GameStopBrowser.new(browser_type_parameter)
    @browser.delete_internet_files(browser_type_parameter)
    $options.default_timeout = 30_000
    $snapshots.setup(@browser, :all)

    #Get the parameters from the csv dataset
    @params = $global_functions.csv
    @sql = $global_functions.sql_file
    @db = $global_functions.db_conn
    @start_page = $global_functions.prop_url.find_value_by_name("url")
    @catalog_svc, @catalog_svc_version = $global_functions.catalog_svc
    @cart_svc, @cart_svc_version = $global_functions.cart_svc
    @account_svc, @account_svc_version = $global_functions.account_svc
    @profile_svc, @profile_svc_version = $global_functions.profile_svc
    @digital_wallet_svc, @digital_wallet_version = $global_functions.digitalwallet_svc
    @purchase_order_svc, @purchase_order_svc_version = $global_functions.purchaseorder_svc
    @velocity_svc, @velocity_svc_version = $global_functions.velocity_svc
  end

  before(:each) do
    @browser.delete_all_cookies_and_verify
    @session_id = generate_guid
  end

  after(:each) do
    @browser.return_current_url
  end

  after(:all) do
    @browser.close_all()
  end

  it "#{$tc_id} #{$tc_desc}" do
    @user_name = @browser.generate_new_user_credentials(prefix = "ui_autogen", domain = "qagsecomprod.oib.com")
    @password = $global_functions.password_generator(10)
    $tracer.report("User Name: #{@user_name}, Password: #{@password}")

    $tracer.trace("Get products")
    @product_urls, @matured_product, @physical_product, @condition, @db_result = @browser.load_test_skus_from_db(@db, @sql.to_s, @velocity_svc, @velocity_svc_version, @catalog_svc, @catalog_svc_version, @params, @session_id)

    @browser.open(@start_page)

    if @params["load_ship_addr_from_profile"] || @params["load_bill_addr_from_profile"]
      $tracer.report("Should Register user and populate profile")
      @browser.register_link.click
      @browser.create_account_form_email.should_exist
      @browser.create_account_form_email.value = @user_name
      @browser.create_account_form_password.should_exist
      @browser.create_account_form_password.value = @password
      @browser.create_account_form_confirm_password.should_exist
      @browser.create_account_form_confirm_password.value = @password
      @browser.create_account_submit_button.should_exist
      @browser.create_account_submit_button.click
      sleep 5

      $tracer.report("Should Access 'My Account' and click on 'Address Book'")
      @browser.my_account_link.click
      @browser.addresses_tab.click

      if @params["load_ship_addr_from_profile"]
        $tracer.report("Should Add Shipping Address To Profile")
        @browser.add_shipping_address_button.should_exist
        @browser.add_shipping_address_button.click

        @browser.chkoutfirstname_label.value = @params["ship_first_name"]
        @browser.chkoutlastname_label.value = @params["ship_last_name"]
        @browser.chkoutaddress1_label.value = @params["ship_addr1"]
        @browser.chkoutcity_label.value = @params["ship_city"]
        @browser.chkoutstate_label.value = @browser.state_abbriviation(@params["ship_state"])
        @browser.chkoutzip_label.value = @params["ship_zip"]
        @browser.chkoutphonenumber_label.value = @params["ship_phone"]
        @browser.save_new_account_button.click
      end

      if @params["load_bill_addr_from_profile"]
        $tracer.report("Should Add Billing Address To Profile")
        @browser.add_billing_address_button.should_exist
        @browser.add_billing_address_button.click

        @browser.chkoutfirstname_label.value = @params["bill_first_name"]
        @browser.chkoutlastname_label.value = @params["bill_last_name"]
        @browser.chkoutaddress1_label.value = @params["bill_addr1"]
        @browser.chkoutcity_label.value = @params["bill_city"]
        @browser.chkoutstate_label.value = @browser.state_abbriviation(@params["bill_state"])
        @browser.chkoutzip_label.value = @params["bill_zip"]
        @browser.chkoutphonenumber_label.value = @params["bill_phone"]
        @browser.save_new_account_button.click
        sleep 5
      end

      @open_id = @account_svc.perform_authorization_and_return_user_and_open_id(@session_id, @user_name, @password, @account_svc_version)
      @cart_id = @profile_svc.perform_get_cart_id(@open_id, @session_id, 'GS_US', @profile_svc_version)

      @browser.add_products_to_cart_by_url(@product_urls, @start_page, @condition, @params, @db_result, @session_id, @cart_id, @cart_svc, @cart_svc_version, @catalog_svc, @catalog_svc_version)

      @browser.add_powerup_rewards_number(@params)
      $tracer.report("Should Check subtotal and total")
      subtotal = @browser.check_cart_subtotal_and_discount(@params)

      @browser.wait_for_landing_page_load
      @browser.continue_checkout_button.click
      @browser.wait_for_landing_page_load

    else
      @browser.add_products_to_cart_by_url(@product_urls, @start_page, @condition, @params, @db_result, @session_id, '', @cart_svc, @cart_svc_version, @catalog_svc, @catalog_svc_version)
      $tracer.trace("PowerUP Rewards")
      @browser.add_powerup_rewards_number(@params)
      subtotal = @browser.check_cart_subtotal_and_discount(@params)
      @browser.wait_for_landing_page_load
      @browser.continue_checkout_button.click
      @browser.create_account_link.should_exist
      @browser.create_account_link.click
      @browser.wait_for_landing_page_load
      @browser.create_account_form_email.should_exist
      @browser.create_account_form_email.value = @user_name
      @browser.create_account_form_password.should_exist
      @browser.create_account_form_password.value = @password
      @browser.create_account_form_confirm_password.should_exist
      @browser.create_account_form_confirm_password.value = @password
      @browser.create_account_submit_button.should_exist
      @browser.create_account_submit_button.click
      sleep 5
    end

    if @matured_product
      $tracer.report("Should Verify Age Gate")
      @browser.wait_for_landing_page_load
      @browser.seventeen_or_older_button.click
    end

    if @browser.chkoutweeklyadoffers_label.exists && !@params["load_ship_addr_from_profile"]
      $tracer.report("Should Fill Out Shipping information")
      @browser.fill_out_shipping_form(@params)
      $tracer.report("Sign up for weekly ads? #{@params["sign_up_weekly_ads"] ? "Yes" : "No"}")
      @browser.chkoutweeklyadoffers_label.click if @params["sign_up_weekly_ads"]
    end

    if @params["billing_address_same_as_shipping"]
      $tracer.report("Should Set Billing Address Same As Shipping")
      @browser.same_address_checkbox.click
      @browser.continue_checkout_button.click
    elsif @params["load_bill_addr_from_profile"]
      $tracer.report("Should Load Bill Address From Profile")
      @browser.continue_checkout_button.click
      @browser.wait_for_landing_page_load
      @browser.chkcountry_label.should_exist
      @browser.chkoutfirstname_label.should_exist
      @browser.chkoutlastname_label.should_exist
      @browser.chkoutaddress1_label.should_exist
      @browser.chkoutaddress2_label.should_exist
      @browser.chkoutcity_label.should_exist
      @browser.chkoutstate_label.should_exist
      @browser.chkoutzip_label.should_exist
      @browser.chkoutphonenumber_label.should_exist
      @browser.continue_checkout_button.should_exist
      @browser.continue_checkout_button.click
    else
      @browser.continue_checkout_button.click
      $tracer.report("Should Fill Out Shipping Address Info.")
      @browser.wait_for_landing_page_load
      @browser.chkcountry_label.value = @params["bill_country"]
      @browser.chkoutfirstname_label.value = @params["bill_first_name"]
      @browser.chkoutlastname_label.value = @params["bill_last_name"]
      @browser.chkoutaddress1_label.value = @params["bill_addr1"]
      @browser.chkoutaddress2_label.value = @params["bill_addr2"]
      @browser.chkoutcity_label.value = @params["bill_city"]
      @browser.chkoutstate_label.value = @params["bill_state"]
      @browser.chkoutzip_label.value = @params["bill_zip"]
      @browser.chkoutphonenumber_label.value = @params["bill_phone"]
      @browser.continue_checkout_button.click
    end

    $tracer.report("Should Select Handling Options")
    @browser.wait_for_landing_page_load
    @browser.set_handling_options(@params)
    @browser.continue_checkout_button.click

    $tracer.trace("Payment Page")
    $tracer.report("Should validate order summary details")
    @browser.wait_for_landing_page_load
    @browser.order_summary_subtotal.should_exist
    @browser.order_summary_tax.should_exist
    @browser.order_summary_total.should_exist

    order_summary_subtotal = money_string_to_decimal(@browser.order_summary_subtotal.innerText)
    order_summary_tax = money_string_to_decimal(@browser.order_summary_tax.innerText)
    order_summary_total = money_string_to_decimal(@browser.order_summary_total.innerText)

    if @params["cc_type"] == "generate"
      $tracer.report("Should generate Credit Card Number for test")
      cc = @browser.generate_credit_card("generate")
      ctype = cc[:ctype].to_s
      $tracer.report("Paid with Generated Credit Card: #{cc.inspect}")
      card_type = ctype.slice(0, 1).capitalize + ctype.slice(1..-1)
    end

    if @params["svs"].empty?
      $tracer.report("Should Enter Credit Card Info")
      #Use generated credit card
      @browser.enter_chkcredit_card_info(card_type, cc[:cnum], cc[:expmnth], cc[:expyr], cc[:cvv]) unless @params["cc_type"] != "generate"

      #Use credit card from data set
      @browser.enter_chkcredit_card_info(@params["cc_type"], @params["cc_number"], @params["cc_month"], @params["cc_year"], @params["cvv"]) unless @params["cc_type"] == "generate"
    else
      $tracer.report("Should Pay with Gift Card")
      svs_balance = @purchase_order_svc.perform_get_svs_balance(@params["svs"], @params["pin"], @session_id, @purchase_order_svc_version)
      @browser.enter_svs_info(@params["svs"], @params["pin"], svs_balance, order_summary_total)
      sleep 3
    end
    @browser.chkoutadd_digital_wallet.click unless @params["add_digital_wallet"]
    $tracer.report("Should Add to Digital Wallet") unless @params["add_digital_wallet"]
    sleep 5

    #Submit the order only if the value of submit_order_flag from csv file is 'true'
    if @params["submit_order_flag"]
      $tracer.report("Should Submit Order")
      order_num = @browser.submit_and_confirm_order(@params, @condition)
      @browser.check_confirmation_page_subtotal(subtotal) unless @params["renew_pur"]

      $tracer.report("Should return order number #{order_num}")
      # Is this a physical product? An order note and at least shipping address should exist. Not for DLC.
      if @physical_product
        $tracer.trace("Order Note")
        @browser.confirm_order_note.should_exist
      end
    end

    $tracer.trace("Find open id and user id")
    @open_id = @account_svc.perform_authorization_and_return_user_and_open_id(@session_id, @user_name, @password, @account_svc_version)

    if @params["load_ship_addr_from_profile"] || @params["load_bill_addr_from_profile"]
      @shipping_addresses, @billing_address = @profile_svc.perform_get_addresses(@open_id, @session_id, 'GS_US', @profile_svc_version)

      if @params["load_ship_addr_from_profile"]
        $tracer.report("Should Validate Profile Shipping Address")
        shipping_address = @shipping_addresses[0]
        shipping_address.city.content.upcase.should == @params["ship_city"].upcase
        shipping_address.recipient_first_name.content.upcase.should == @params["ship_first_name"].upcase
        shipping_address.recipient_last_name.content.upcase.should == @params["ship_last_name"].upcase
        shipping_address.address_line1.content.upcase.should == @params["ship_addr1"].upcase
        shipping_address.state_or_province.content.upcase.should == @browser.state_abbriviation(@params["ship_state"])
        shipping_address.postal_code.content.should == @params["ship_zip"]
      end

      if @params["load_bill_addr_from_profile"]
        $tracer.report("Should Validate Profile Billing Address")
        @billing_address.city.content.upcase.should == @params["bill_city"].upcase
        @billing_address.recipient_first_name.content.upcase.should == @params["bill_first_name"].upcase
        @billing_address.recipient_last_name.content.upcase.should == @params["bill_last_name"].upcase
        @billing_address.address_line1.content.upcase.should == @params["bill_addr1"].upcase
        @billing_address.state_or_province.content.upcase.should == @browser.state_abbriviation(@params["bill_state"])
        @billing_address.postal_code.content.should == @params["bill_zip"]
      end
    end

    if @params["add_digital_wallet"]
      $tracer.trace("Should Validate Added to Digital Wallet")
      digital_wallet_rsp = @digital_wallet_svc.perform_get_wallets(@digital_wallet_version, @open_id)
      $tracer.trace(digital_wallet_rsp.http_body.formatted_xml)
      payment_method = digital_wallet_rsp.http_body.find_tag("payment_method").at(0)
      if @params["cc_type"] != "generate"
        payment_method.type[1].content.should == @params["cc_type"].gsub(/\s+/, "")
        payment_method.pan_last_four.content.should == @params["cc_number"][-4, 4]
        payment_method.expiration_month.content.should == @params["cc_month"].to_i.to_s
        payment_method.expiration_year.content.should == @params["cc_year"]
      else
        payment_method.type[1].content.should == card_type.gsub(/\s+/, "")
        payment_method.pan_last_four.content.should == cc[:cnum][-4, 4]
        payment_method.expiration_month.content.should == cc[:expmnth].to_i.to_s
        payment_method.expiration_year.content.should == cc[:expyr]
      end
    end

  end

end