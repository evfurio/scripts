### TODO: Template Description of this script
# d-Con %QAAUTOMATION_SCRIPTS%\GameStopRespMobile\spec\UI\mgs_checkout_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStopRespMobile\spec\UI\mgs_responsive_dataset.csv --range TFS96873 --browser chrome --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStopRespMobile/dsl/src/dsl"

$tracer.mode=:on
$tracer.echo=:on
$global_functions = GlobalFunctions.new()

$tc_desc = $global_functions.desc
$tc_id = $global_functions.id
$tracer.trace("THIS IS TEST DESC #{$tc_desc} \nTHIS IS TEST ID #{$tc_id}")

describe "MGS NextGen Checkout" do

  before(:all) do
    #Get the parameters from the csv dataset
    @params = $global_functions.csv
    @sql = $global_functions.sql_file
    @db = $global_functions.db_conn
    @login = $global_functions.login
    @password = $global_functions.password
    @start_page = $global_functions.prop_url.find_value_by_name("url")
    @catalog_svc, @catalog_svc_version = $global_functions.catalog_svc
    @cart_svc, @cart_svc_version = $global_functions.cart_svc
    @account_svc, @account_svc_version = $global_functions.account_svc
    @profile_svc, @profile_svc_version = $global_functions.profile_svc
    @digital_wallet_svc, @digital_wallet_version = $global_functions.digitalwallet_svc
    @purchase_order_svc, @purchase_order_svc_version = $global_functions.purchaseorder_svc
    @velocity_svc, @velocity_svc_version = $global_functions.velocity_svc
    @shipping_svc, @shipping_svc_version = $global_functions.shipping_svc

    $options.http_proxy = "localhost"
    $options.http_proxy_port = "9091"

    $proxy = ProxyServerManager.new(9091)

    @browser = WebBrowser.new(browser_type_parameter, true)
    @browser.delete_internet_files(browser_type_parameter)

    ### TODO: change to 20 and remove wait
    $options.default_timeout = 10_000
    $snapshots.setup(@browser, :all)

    # Get the size, view and user agent of the device
    @device, device_width, device_heigth, @device_user_agent = @browser.get_user_agent_and_device_size(@params)
    $tracer.trace("DEVICE SIZE - W: #{device_width}, H: #{device_heigth}")
    @browser.set_size(device_width, device_heigth)

  end

  before(:each) do
    ### TODO: Move to before all
    $proxy.inspect
    $proxy.start
    sleep 5



    @browser.delete_all_cookies_and_verify
    @session_id = generate_guid
  end

  after(:each) do
    ### TODO: move to after all
    $proxy.stop


    @browser.return_current_url
  end

  after(:all) do
    @browser.close_all()
  end

  it "#{$tc_id} #{$tc_desc}" do
    $proxy.set_request_header("User-Agent", @device_user_agent)

    # Check if user is Authenticated or Guest
    is_guest_user = false
    unless @params['login'] == ""
      @open_id = @account_svc.perform_authorization_and_return_user_and_open_id(@session_id, @login, @password, @account_svc_version)
      @cart_id = @profile_svc.perform_get_cart_id(@open_id, @session_id, 'GS_US', @profile_svc_version)
      @cart_svc.perform_empty_cart(@session_id, @cart_id, 'GS_US', 'en-US', @cart_svc_version)

      @browser.open("#{@start_page}")

      ### TODO: Validation for Tablet and Phone for Login
      if @device.upcase.strip == "PHONE"
        @browser.mgs_hdr_mobile_hamburger.click
        @browser.mgs_hdr_mobmnu_signin_lnk.click
      else
        @browser.mgs_hdr_tab_signin_menu.click
        @browser.mgs_hdr_tab_signin_btn.click
      end
        ### TODO: Move this to dsl
        @browser.wait_for_landing_page_load
        @browser.email_address_field.value = @login
        @browser.password_field.value = @password
        @browser.log_in_button.click
        sleep 5
    else
      @browser.open("#{@start_page}")
      is_guest_user = true
    end

    @browser.open("#{@start_page}/browse")

    # Construct SQL Query  -OR-  Use SKU from Dataset
    ### TODO: Probably better if will be moved to dsl
    if @params['sku'] == ""
      $tracer.trace("Construct SQL Query")
      @esrb_ratings = @params['esrb_rating'].length > 1 ? @params['esrb_rating'].split(",").join("','") : @params['esrb_rating']
      @excluded_skus = @params['esrb_rating'].length > 1 ? @params['excluded_skus'].split(",").join("','") : @params['excluded_skus']
      @conditions = @params['condition'].length > 1 ? @params['condition'].split(",").join("','") : @params['condition']
      @availability = @params['availability'].length > 1 ? @params['availability'].split(",").join("','") : @params['availability']
      unless @params['product_limit'] == ""
        @product_limit = @params['product_limit'] == "NULL" ? "AND d.ProductLimit is NULL" : "AND d.ProductLimit = #{@params['product_limit']}"
      else
        @product_limit = ""
      end
      unless @params['on_hand_quantity'] == ""
        @on_hand_quantity = @params['on_hand_quantity'] > "0" ? "AND i.onhandquantity > 0" : "AND i.onhandquantity <= 0"
      else
        @on_hand_quantity = ""
      end
      unless @params['has_release_date'] == ""
        @release_date = @params['has_release_date'] == true ? "AND i.PreorderAvailabilityDate > GETDATE()" : "AND i.StreetDate is NULL AND i.PreorderAvailabilityDate is NULL"
      else
        @release_date = ""
      end
      unless @params['is_online_only_price'] == ""
        @online_only_price = @params['is_online_only_price'] == true ? "AND c.OnlineOnlyPrice = 1" : "AND c.OnlineOnlyPrice = 0"
      else
        @online_only_price = ""
      end
      unless @params['is_online_only'] == ""
        @online_only = @params['is_online_only'] == true ? "AND c.OnlineOnly = 1" : "AND c.OnlineOnly = 0"
      else
        @online_only = ""
      end
      unless @params['is_backorderable'] == ""
        @backorderable = @params['is_backorderable'] == true ? "AND i.Backorderable = 1" : "AND i.Backorderable = 0"
      else
        @backorderable = ""
      end
      unless @params['backorder_limit'] == ""
        @backorder_limit = @params['backorder_limit'] > "0" ? "AND i.BackorderLimit > 0" : "AND i.BackorderLimit <= 0"
      else
        @backorder_limit = ""
      end
      unless @params['is_preorderable'] == ""
        @preorderable = @params['is_preorderable'] == true ? "AND i.Preorderable = 1" : "AND i.Preorderable = 0"
      else
        @preorderable = ""
      end
      unless @params['preorder_limit'] == ""
        @preorder_limit = @params['preorder_limit'] > "0" ? "AND i.PreorderLimit > 0" : "AND i.PreorderLimit <= 0"
      else
        @preorder_limit = ""
      end
      sql_query = create_sql(@params['return_product_num'], @esrb_ratings, @on_hand_quantity, @availability, @conditions, @params['is_available'], @params['is_searchable'], @product_limit, @excluded_skus, @release_date, @online_only_price, @online_only, @backorderable, @backorder_limit, @preorderable, @preorder_limit, @sql)
    else
      sql_query = create_sql_by_sku(@params['return_product_num'], @params['sku'], @sql)
    end
    @results_from_file = @db.exec_sql("#{sql_query}")

    # Get Product Details from Catalog Service
    sku_id, *prod_attr, @product = @browser.get_product_from_query(@results_from_file, @catalog_svc, @catalog_svc_version, @params, @session_id)
    products_to_test = @product['product_urls']

    products_to_test.each_with_index do |tests, i|
      $tracer.report("VariantID SKU :::::   #{@product['sku_id'][i]}")
      $tracer.trace("Product URL :::::   #{@product['product_urls'][i].to_s.strip}")
      ### TODO: Automation Framework to fix issue on special characters
      # $tracer.trace("Display Name :::::   #{@product['display_name'][i].to_s.strip}")
      # $tracer.trace("Platform :::::   #{@product['platform'][i].to_s.strip}")
      $tracer.trace("Platform Count :::::   #{@product['platform_count'][i]}")
      $tracer.trace("Review Count :::::   #{@product['review_count'][i]}")
      $tracer.trace("ESRB Image :::::   #{@product['esrb_img'][i].to_s.strip}")
      $tracer.trace("Developer :::::   #{@product['developer'][i].to_s.strip}")
      $tracer.trace("Publisher :::::   #{@product['publisher'][i].to_s.strip}")
      $tracer.trace("Availability :::::   #{@product['availability'][i].to_s.strip}")
      $tracer.trace("Condition :::::   #{@product['condition'][i].to_s.strip}")
      $tracer.trace("Product Type :::::   #{@product['product_type'][i].to_s.strip.upcase}")
      $tracer.trace("List Price :::::   #{@product['list_price'][i].to_s.strip}")

      url = @product['product_urls'][i].to_s.strip
      title = @browser.convert_to_utf8(@product['display_name'][i].to_s.strip)
      platform = @browser.convert_to_utf8(@product['platform'][i].to_s.strip)
      platform_count = @product['platform_count'][i].to_i
      review_count = @product['review_count'][i].to_i
      esrb_img = @product['esrb_img'][i].to_s.strip
      developer = @product['developer'][i].to_s.strip
      publisher = @product['publisher'][i].to_s.strip
      availability = @product['availability'][i].to_s.strip
      condition = @product['condition'][i].to_s.strip.upcase
      product_type = @product['product_type'][i].to_s.strip.upcase
      price = @product['list_price'][i].to_s.strip
      is_online_only = @product['is_online_only'][i].to_s.upcase.strip.eql?("TRUE") ? true : false
      has_bonus_item = @product['has_bonus_item'][i].to_s.upcase.strip.eql?("TRUE") ? true : false
      # Other product_info retrieved from db - NOT included in catalog service response
      is_online_only_price = @results_from_file[i].OnlineOnlyPrice
      on_hand_quantity = @results_from_file[i].OnHandQuantity
      preorderable = @results_from_file[i].Preorderable
      preorder_limit = @results_from_file[i].PreorderLimit

      # Logic for multiplatform and single platform products
      @product_url = @browser.open_product_url(@start_page, url, platform_count)

      # Validation for product cartridges
      @browser.validate_if_multiplatform(@product_url, platform_count)
      @browser.validate_product_canonical_url(url)
      # @browser.validate_product_zen_catridge(@params, title, platform, platform_count, review_count)
      # @browser.validate_tabs_catridge(@params)
      # @browser.validate_product_reviews_cartridge
      # @browser.validate_product_rating_cartridge(esrb_img, developer, publisher)
      # @browser.validate_recommendations_cartridge(@device)
      #
      # @browser.validate_bonus_cartridge(has_bonus_item)


      # PURCHASE OPTIONS Cartridge
      ### TODO: Move to dsl once the user stories are completed
      $tracer.trace("PURCHASE OPTIONS Cartridge")
      @browser.mgs_product_purchaseopt_section.should_exist

      ### TODO: More validations to come for PickUp@Store (HOPS)
      if is_online_only == true or (product_type == "DIGITAL" and condition == "NEW")
        $tracer.trace("Product is NOT for HOPS or Pick Up At Store")
        @browser.mgs_shipopt_list.should_not_exist
      end

      @browser.mgs_purchaseopt_section.should_exist
      @browser.mgs_purchaseopt_list.length.should > 0
      i=0
      is_unavailable_online = false
      while i < @browser.mgs_purchaseopt_list.length
        @browser.mgs_purchaseopt_label.at(0).should_exist
        is_unavailable_online = @browser.mgs_purchaseopt_list.at(0).get("class").split(" ").include?("disabled") == true ? true : false
        if (preorderable == true and preorder_limit <= 0 and on_hand_quantity <= 0) or availability == "NFS"
          $tracer.trace("Product is UNAVAILABLE ONLINE")
          @browser.mgs_purchaseopt_label.at(0).innerText.strip.upcase.should include "UNAVAILABLE ONLINE"
          is_unavailable_online.should == true
        end
        if is_online_only_price == true and is_unavailable_online == false
          $tracer.trace("Product is ONLINE ONLY")
          @browser.mgs_purchaseopt_onlineonly.at(0).should_exist
          @browser.mgs_purchaseopt_onlineonly.at(0).innerText.strip.should == "(Online Only)"
        end
        condition = "PRE-OWNED" if condition == "USED"
        condition = "DIGITAL" if (product_type == "DIGITAL" and condition == "NEW")
        condition_ui = @browser.mgs_purchaseopt_condition[0].innerText.strip.upcase
        condition_ui.should == "#{condition}"
        $tracer.trace("SVC :::::  #{condition}     UI :::::  #{condition_ui}")

        list_price_svc = money_string_to_decimal(price)
        list_price_ui = money_string_to_decimal(@browser.mgs_purchaseopt_price[0].innerText.strip.gsub(/[$]/,''))
        list_price_svc.should == list_price_ui
        $tracer.trace("SVC :::::  #{list_price_svc}     UI :::::  #{list_price_ui}")
        i+=1
      end
      # @browser.take_snapshot("#{$tc_id}")




      # Continue to Cart if product is available
      unless is_unavailable_online
        @browser.go_to_cart_modal
        @browser.continue_shopping(@product_url) if @params['add_to_cart'] == false

        if @params['add_to_cart'] == true
          # Check Out Now
          @browser.mgs_cart_modal_chkout_btn.click
          @browser.wait_for_landing_page_load
          $tracer.trace("YOU HAVE REACHED THE LEGACY CART PAGE!!!")


          if @params["use_paypal_at_cart"]
            $tracer.trace("------------------------- THIS IS THE ENTRY TO PAYPAL IN THE CART")
            @browser.paypal_chkout_button.click

            $tracer.trace("------------------------- Log Into PayPal")
            # @browser.paypal_sandbox_login
            @browser.retry_until_found(lambda{@browser.div.className("/emailField/").input.exists != false}, 10)
            @browser.div.className("/emailField/").input.value = "davidturner@gamestop.com"
            @browser.div.className("/passwordField/").input.value = "4baV239056"
            @browser.input.className("/loginBtn/").click
            sleep 5

          else
            $tracer.trace("*********************** Continue Secure Checkout")
            if @params["add_product_qty"] == true
              @browser.retry_until_found(lambda{@browser.edit_cart_link.exists != false}, 10)
              @browser.edit_cart_link.click
              @browser.qty_update_field.value = "2"
              @browser.cart_edit_done_link.click
              @browser.line_item_label.should_exist
              @browser.qty_update_field.value.should == "2"
              @browser.wait_for_landing_page_load
            end
            @browser.continue_checkout_button_handling.click
            @browser.wait_for_landing_page_load

            if is_guest_user
              $tracer.trace("*********************** How Do You Want To Checkout? screen")
              @browser.buy_as_guest_button.click
              @browser.wait_for_landing_page_load
            end
          end

          if esrb_img.include?("m.gif")
            $tracer.trace("*********************** Age Check screen")
            @browser.seventeen_or_older_button.click unless @params["use_paypal_at_cart"]
            @browser.wait_for_landing_page_load
          end

          if @params["use_paypal_at_cart"]
            $tracer.trace("------------------------- Continue through PayPal")
            @browser.input.className("/continueButton/").click
            sleep 5
            @browser.seventeen_or_older_button.click if esrb_img.include?("m.gif")

            #Handling options only apply to physical products
            unless product_type == "DIGITAL"
              $tracer.trace("------------------------- Handling Options screen")
              @browser.chkout_handling_options_label.should_exist
              @browser.shipping_handling_option_label.find.input[1].click #Standard
              @browser.wait_for_landing_page_load
              @browser.continue_checkout_button_handling.click
              @browser.wait_for_landing_page_load
            end
          else
            unless product_type == "DIGITAL"
              $tracer.trace("*********************** Shipping Address screen")
              if is_guest_user
                @browser.enter_address_plus_email(@params["first_name"], @params["last_name"], @params["shipping_line1"], @params["shipping_city"], @params["shipping_state"], @params["shipping_zip"], @params["shipping_phone"], @params["shipping_email"])
              else
                if @browser.chkout_select_existing_address.inner_text.length == 0
                  @browser.enter_address(@params["first_name"], @params["last_name"], @params["shipping_line1"], @params["shipping_city"], @params["shipping_state"], @params["shipping_zip"], @params["shipping_phone"])
                end
                if @params["change_existing_address"]
                  ### TODO: Put something here!!!!
                end
              end
              @browser.show_order_summary_link.click

              if @params["billing_address_same_as_shipping"]
                @browser.chkout_same_address_checkbox.checked = true
              else
                $tracer.trace("*********************** Billing Address screen")
                @browser.continue_checkout_button_handling.click
                @browser.wait_for_landing_page_load
                @browser.show_order_summary_link.click
                @browser.wait_for_landing_page_load
                if @browser.chkout_select_existing_billing_address.inner_text.length == 0
                  @browser.enter_billship_address(@params["first_name"], @params["last_name"], @params["billing_line1"], @params["billing_city"], @params["billing_state"], @params["billing_zip"], @params["billing_phone"])
                end
              end
              @browser.continue_checkout_button_handling.click
              @browser.wait_for_landing_page_load

              $tracer.trace("*********************** Handling Options screen")
              @browser.show_order_summary_link.click

              @browser.chkout_gift_message_field.value = "Gift Message Box should only contain 50 characters"
              @browser.chkout_gift_message_field.value.length.should_not > 50

              @browser.chkout_handling_options_label.should_exist
              @browser.shipping_handling_option_label.find.input[1].click   #Standard

            else
              $tracer.trace("*********************** Billing Address screen - DLC Product")
              @browser.show_order_summary_link.click
              if is_guest_user
                @browser.enter_billing_address_plus_email(@params["first_name"], @params["last_name"], @params["billing_line1"], @params["billing_city"], @params["billing_state"], @params["billing_zip"], @params["billing_phone"], @params["billing_email"])
              else
                if @browser.chkout_select_existing_billing_address.inner_text.length == 0
                  @browser.enter_address(@params["first_name"], @params["last_name"], @params["billing_line1"], @params["billing_city"], @params["billing_state"], @params["billing_zip"], @params["billing_phone"])
                end
              end
            end
            @browser.continue_checkout_button_handling.click
            @browser.wait_for_landing_page_load

            $tracer.trace("*********************** Payment Options screen")
            @browser.show_order_summary_link.click
            @browser.unused_promocode_message.should_not_exist

            if @params["use_paypal_at_payment"]
              @browser.paypal_payment_option.click
              @browser.paypal_continue_button.click
              @browser.wait_for_landing_page_load

              $tracer.trace("Log Into PayPal")
              # @browser.paypal_sandbox_login
              @browser.retry_until_found(lambda{@browser.div.className("/emailField/").input.exists != false}, 10)
              @browser.div.className("/emailField/").input.value = "davidturner@gamestop.com"
              @browser.div.className("/passwordField/").input.value = "4baV239056"
              @browser.input.className("/loginBtn/").click
              sleep 5
              $tracer.trace("Continue through PayPal")
              # @browser.paypal_test_acct_continue_button.click
              @browser.input.className("/continueButton/").click
              sleep 5

            else
              @browser.cc_payment_option.click
              @browser.wait_for_landing_page_load
              if @params["svs_number"].empty?
                $tracer.trace("Pay With A Credit Card")

                if @params["change_existing_address"]
                  $tracer.trace("Change address Link on Payment Page")
                  @browser.change_address_payment_page_link.click
                  @browser.enter_billship_address(@params["first_name"], @params["last_name"], @params["billing_line1"], @params["billing_city"], @params["billing_state"], @params["billing_zip"], @params["billing_phone"])
                  if product_type == "DIGITAL"
                    #if DLC, the system will ask for Email address
                    @browser.chkout_email_address_field.value = @params["billing_email"]
                    @browser.chkout_billing_confirm_email_address_field.value = @params["billing_email"]
                  end
                  @browser.continue_checkout_button_handling.click
                  @browser.wait_for_landing_page_load
                  @browser.retry_until_found(lambda{@browser.cc_payment_option.exists != false})
                  @browser.cc_payment_option.click
                  @browser.wait_for_landing_page_load
                end
                $tracer.trace("Enter Credit Card Info")
                @browser.chkout_digital_wallet_selector.value = "-- Select a Card--" if @browser.chkout_digital_wallet_selector.exists
                @browser.enter_credit_card_info(@params["cc_type"], @params["cc_number"], @params["exp_month"], @params["exp_year"], @params["cvv"])
              else
                $tracer.trace("Pay With A PowerUp Rewards, Trade Card, or Gift Cards")
                @browser.chkout_gift_card_field.value = @params["svs_number"]
                @browser.chkout_gift_card_pin_field.value = @params["svs_pin"]
                @browser.gift_card_apply_button.click
                @browser.wait_for_landing_page_load
              end
            end
          end

          if @params["submit_order"]
            @browser.submit_order
            $tracer.trace("*********************** Order Confirmation screen")
            @browser.validate_order_prefix("(5|8)1")
            @browser.take_snapshot("+++++++++++++++")
          end

        end
      end

    end
  end


  def create_sql(return_product_num, esrb_rating, on_hand_quantity, availability, condition, is_available, searchable, product_limit, excluded_skus, release_date, online_only_price, online_only, backorderable, backorder_limit, preorderable, preorder_limit, sql)
    template = explode_sql_from_file(sql)
    sql = ERB.new(template).result(binding)
    $tracer.trace("#{sql}")
    return sql
  end

  def create_sql_by_sku(return_product_num, sku, sql)
    template = explode_sql_from_file(sql)
    sql = ERB.new(template).result(binding)
    $tracer.trace("#{sql}")
    return sql
  end

  def explode_sql_from_file(filename)
    sql = ""
    filename = filename.gsub(/\\/, "/")
    if File.file?(filename)
      expanded_filename = File.realdirpath(filename)
      begin
        sql = File.read(expanded_filename)
      rescue Exception => ex
        raise ToolException.new(ex, "unable to perform sql statement, cannot read '#{expanded_filename}': #{ex.message}")
      end
    else
      raise Exception, "unable to perform sql statement: unable to locate '#{filename}'"
    end
    return sql
  end


end