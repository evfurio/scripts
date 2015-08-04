# Function Library - Cart

## Functions should include steps that allow a specification to get, add, update, remove, modify information for elements of the targeted SUT/AUT
## No validations should occur in the function library, only transfer of data or interaction with elements/attributes

module GameStopCartFunctions

#CART GET OPERATIONS
  def get_cart_state
    $tracer.trace("GameStopCartFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    # get cart from cart service, though we can't see this for guest users yet
      #cart_rsp = nil
    # is this a guest or authenticated user?
      #is_guest_user = false
    # will the cart be empty or populated with items upon entry?
      #is_cart_empty = true
    # if populated, how many items and the details of those products (price, title, shipping options)
      #line_item_list = cart_rsp.line_items
    # what is the expected cookie drop
      #cookies = []
    # collect any analytics of use (omniture, google analytics, channel intelligence)
      #analytics = []
    # get the list of recommended products
      #recommended_products = []
    # is there an auto fired promo code in this cart?
      #is_promo_code_in_cart = false
    states = []
    return states
  end

  def get_cart_line_item_length
    $tracer.trace("GameStopCartFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
  end


  def load_test_skus_from_csv(velocity_svc, velocity_svc_version, catalog_svc, catalog_svc_version, params, session_id)
		$tracer.trace("GameStopCartFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    product_urls = []
    condition = []
    matured_product = false
    physical_product = false
		
    $tracer.trace("Product Sku from csv :::::  #{params["sku"]}")
		$tracer.trace("Call velocity service to check availability for #{params["sku"]} ")
		velocity_status = velocity_svc.velocity_check(session_id, generate_guid, params["ship_email"], params["sku"], params["ship_addr1"], params["ship_addr2"], params["ship_city"], state_abbriviation(params["ship_state"]), params["ship_county"], params["ship_zip"], country_code(params["ship_country"]), params["bill_addr1"], params["bill_addr2"], params["bill_city"], state_abbriviation(params["bill_state"]), params["bill_county"], params["bill_zip"], country_code(params["bill_country"]), velocity_svc_version)
		
		if velocity_status.upcase.eql?("PASS")
			catalog_rsp = catalog_svc.perform_get_product_by_sku(catalog_svc_version, session_id, params["sku"])
			product_urls << catalog_rsp.http_body.find_tag("product").at(0).url.content
			matured_product = (catalog_rsp.http_body.find_tag("product").at(0).esrb_rating.content.eql?("M") ? true : false) 
			physical_product = (catalog_rsp.http_body.find_tag("product").at(0).condition.content.eql?("Digital") ? false : true) 
			condition << catalog_rsp.http_body.find_tag("product").at(0).condition.content
			
			$tracer.trace("Product URL :::::  #{catalog_rsp.http_body.find_tag("product").at(0).url.content}")
			$tracer.trace("ESRB Rating :::::  #{catalog_rsp.http_body.find_tag("product").at(0).esrb_rating.content}")
			$tracer.trace("Condition :::::  #{catalog_rsp.http_body.find_tag("product").at(0).condition.content}")
			$tracer.trace("Matured_product :::::  #{matured_product}     Physical_product :::::  #{physical_product}")
		end
		
		return product_urls, matured_product, physical_product, condition, nil
  end


  def load_test_skus_from_db(db, sql, velocity_svc, velocity_svc_version, catalog_svc, catalog_svc_version, params, session_id)
    $tracer.trace("GameStopCartFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    product_urls = []
    condition = []
    matured_product = false
    physical_product = false
    results_from_file = db.exec_sql_from_file("#{sql}")
    number_of_products = results_from_file.length
    while product_urls.length < number_of_products
      results_from_file.each do |sku|
        $tracer.trace("Call velocity service to check availability for #{sku} ")
        velocity_status = velocity_svc.velocity_check(session_id, generate_guid, params["ship_email"], sku.variantid, params["ship_addr1"], params["ship_addr2"], params["ship_city"], state_abbriviation(params["ship_state"]), params["ship_county"], params["ship_zip"], country_code(params["ship_country"]), params["bill_addr1"], params["bill_addr2"], params["bill_city"], state_abbriviation(params["bill_state"]), params["bill_county"], params["bill_zip"], country_code(params["bill_country"]), velocity_svc_version)

        if velocity_status.upcase.eql?("PASS")
          product_urls << catalog_svc.perform_get_product_url(catalog_svc_version, session_id, sku.variantid)
          matured_product = (sku.esrbrating.eql?("M") ? true : false) if !matured_product
          # We want this if we have any physical products because we're going to use it to determine whether a shipping address is needed/to be checked
          physical_product = (sku.condition.eql?("Digital") ? false : true) if !physical_product
          condition << sku.condition
        end
      end
      if product_urls.length < number_of_products
        results_from_file = db.exec_sql_from_file("#{sql}")
      end
    end
    return product_urls, matured_product, physical_product, condition, results_from_file
  end

#CART ADD/APPLY OPERATIONS

  # ANNOTATION: This method has more validation than normal due to the iterating through product information and validating per instance.  There is a better approach but requires some
  # heavy refactoring that we're not yet prepared for.  This is on the Scripts 3.0+ road map.
  def add_products_to_cart_by_url(product_urls, start_page, condition, params, db_result, session_id, cart_id, cart_svc, cart_svc_version, catalog_svc, catalog_svc_version)
    $tracer.trace("GameStopCartFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.trace(product_urls)
    i = 0
    product_urls.each_with_index do |url|
      open("#{start_page}#{url}")
      $tracer.report("Should #{__method__}: #{start_page}#{url}.")
      retry_until_found(lambda{buy_first_panel.exists != false}, 10)
      buy_first_panel.should_exist
      validate_product_conditions(condition, i)
      product_detail_title = convert_to_utf8(product_title)
      product_price = buy_first_panel.price.gsub(/[$]/, '')
      #Validates that the pur pro price displayed for used products is correct using math
      if condition.to_s.strip.upcase! == "USED"
        product_pur_price = validate_product_pur_pro_price
        pur_discount = product_price * 0.10
        product_pur_price.should == pur_discount
        discount_total.push(pur_discount.to_f)
        discount_sum = calculate_pur_discount(discount_total)
      end

      #TODO: give the choice of selecting any of the products displayed; put the selector method in the PDP DSL
      #Adding the first product shown
      buy_first_panel.add_to_cart_button.click
      #OPTIMIZE: If we give the power to select different buy boxes than the first displayed we'll have to know what the variant is that was selected
      validate_upsell_modal if params["do_upsell"]
      sleep 3
			cart_list.at(i).shipping_option_buttons.value = "PickUpAtStore" if params["do_ispu"]
			#TODO: Validation Method for PayPal should have a kill switch in case the feature is turned off, it should also not live in the functions as it is a validation
			validate_paypal_button(params) unless params["do_ispu"]
			cart_list.at(i).remove_button.should_exist
      unless params["do_merge_cart"]
        if product_urls.length == 1  # b/c there are instances that products interchange in cart page
          cart_page_availability = self.validate_product_details_in_cart(cart_list.at(i), product_detail_title, product_price) #method in game_stop_cart_functions
          #FIXME: cart_id can't be an empty value at this point can it?  Seems likely this would allow potential bugs through.
          #ANNOTATION: The cart_id == '' comes from the new user checkout script.  This is kind of confusing so let's revisit the way this is handled.
          self.validate_products_in_cart_service(session_id, cart_id, cart_svc, cart_svc_version, product_detail_title, product_price, cart_page_availability, i) unless cart_id == ''
          validate_cookies_and_tags(params)

          unless db_result.nil?
            validate_product_details_in_catalog_svc(catalog_svc, catalog_svc_version, session_id, db_result[i], product_detail_title, product_price, cart_page_availability) if i < db_result.length
          end
        end
      end
      i += 1
    end

  end

  def add_products_to_cart_by_url_ispu(product_urls, start_page, condition, params, db_result)
    $tracer.trace("GameStopCartFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    item_num = 0
    i = 0
    product_urls.each do |url|
      $tracer.trace("Product Url: #{url}")
      open("#{start_page}#{url}")
      # FIXME : Requires an assertion for the value returned
      #@pur_price = check_for_pur_pro_price if condition.to_s.strip.upcase! == "USED"
      buy_first_panel.add_to_cart_button.click
      wait_for_landing_page_load
      validate_cookies_and_tags(params)
      cart_item = cart_list.at(item_num)
      # Validate item exists in the cart
			unless db_result.nil?
				if i < db_result.length
					validate_upsell_modal if db_result[i].EnableUpsellRecommendations == true
					if db_result[i].SuppressReleaseDate == true
						$tracer.trace("This Release Date of the product is suppressed.")
						cart_item.availability_label.inner_text.should_not include "#{db_result[i].ReleaseDate}"
						cart_item.availability_label.inner_text.should include 'Pre-order and pick it up on release day'
					else
						$tracer.trace("This will show the Release Date of the product.")
						cart_item.availability_label.inner_text.should include "#{db_result[i].ReleaseDate}"
						cart_item.availability_label.inner_text.should include 'Pre-order and pick it up on release day'
					end
					i = i + 1
				end
			end
      cart_item.remove_button.should_exist
      cart_item.shipping_option_buttons.should_exist
			retry_until_found(lambda{paypal_chkout_button.exists != false}, 10)
      paypal_chkout_button.should_exist
      cart_item.shipping_option_buttons.value = "PickUpAtStore" if params["do_ispu"]
      item_num = item_num + 1
    end
  end

  def add_renewal_sku_to_cart_by_url(renewal_type, start_page)
    $tracer.trace("GameStopCartFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    start_url = start_page.gsub('http://', 'https://')
    renewal_url = "#{start_url}/LoyaltyAddToCart.aspx?renewaltype=#{renewal_type}"
    $tracer.trace("Renewal Url: #{renewal_url}")
    return renewal_url
  end

  def add_products_to_cart_by_service(db, sql, velocity_svc, velocity_svc_version, catalog_svc, catalog_svc_version, params, session_id, user_id, cart_svc, cart_svc_version)
    $tracer.trace("GameStopCartFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    sku_qty_list = []
    qty_increase = 0
    product_urls = nil
    matured_product = nil
    physical_product = nil
    product_urls, matured_product, physical_product, condition, results_from_file = load_test_skus_from_db(db, sql, velocity_svc, velocity_svc_version, catalog_svc, catalog_svc_version, params, session_id)
    results_from_file.each_with_index do |sku, i|
      qty = i == 2 ? 1 + qty_increase.to_i : 1
      qty = 1
      sku_qty_list.push(sku.variantid, qty)
    end

    cart_svc.perform_add_products_to_cart(session_id, user_id, *sku_qty_list, client_channel = 'GS_US', locale = 'en-us', cart_svc_version)
    return matured_product, physical_product
  end

  def add_powerup_rewards_number(params)
    $tracer.trace("GameStopCartFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__} #{params["powerup_number"]}.")
    $tracer.trace(puts !params["powerup_number"].blank?)
    if !params["powerup_number"].blank?
      powerup_rewards_number_field.value = params["powerup_number"]
      apply_button.click
      pur_cart_total = validate_pur_discount
    elsif params["powerup_number"].blank?
      powerup_rewards_number_field.value.length > 0
      pur_cart_total = validate_pur_discount
    else
      pur_cart_total = nil
    end
    return pur_cart_total
  end

  def add_recommended_product_from_cart
    $tracer.trace("GameStopCartFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
  end

  def add_promo_code(params)
    $tracer.trace("GameStopCartFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")

    unless params["promo_code_number"].blank?
      retry_until_found(lambda{promo_code_field.exists != false}, 10)
      promo_code_field.value = params['promo_code_number']
      apply_button.click
      discount_amount_from_cart.should_exist unless params['discount_type'] == 'shipping'
    end
  end

#CART UPDATE OPERATIONS
  def update_product_quantity
    $tracer.trace("GameStopCartFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
  end

  def update_powerup_rewards_number
    $tracer.trace("GameStopCartFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
  end

#CART DELETE OPERATIONS
  def remove_single_product_in_cart
    $tracer.trace("GameStopCartFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    #remove only a single item from cart
  end

  def remove_multiple_products_in_cart
    $tracer.trace("GameStopCartFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    #remove multiple items from cart staring with top down
  end

  def remove_random_product_in_cart
    $tracer.trace("GameStopCartFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    #from cart, randomly select a product to remove
  end

  def remove_all_products_in_cart
    $tracer.trace("GameStopCartFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    #from cart, remove each line item staring with top down
  end

  def remove_all_products_in_cart_randomly
    $tracer.trace("GameStopCartFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    #from cart, remove each line item in a random order
  end

  def remove_recommended_product_in_cart
    #get the recommended product list, add the recommended product, verify it was added and then remove it
    $tracer.trace("GameStopCartFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    #from cart, add recommended product from recommendations list
    #confirm recommended product is added to the line items
    #remove the recommended product from the cart
    #verify the product is removed
    #refresh the page and verify the product is still removed
  end

  def remove_promo_code
    $tracer.trace("GameStopCartFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    # Validate if discount will disappear after removing the coupon
    remove_coupon_from_cart.click
    wait_for_landing_page_load
    discount_amount_from_cart.should_not_exist
  end

  def empty_new_cart #refactor to be named "remove_all_products_in_cart"
    $tracer.trace("GameStopCartFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    my_cart_button.click
    wait_for_landing_page_load
    ensure_header_loaded
    #shopping_cart_label.should_exist
    len = timeout(1000).cart_list.length
    # Added logic since CartList class has length as length-1 - if component changes, this IF is not needed
    if cart_list.exists
      len+=1
    end

    while len > 0
      cart_list.at(0).remove_button.click
      wait_for_landing_page_load
      ensure_header_loaded
      len-=1
    end
  end

  # Delete items from the wish list until the wish list is emptied.
  def empty_wish_list
    $tracer.report("Should #{__method__}.")
    $tracer.trace("GameStopCartFunctions: #{__method__}, Line: #{__LINE__}")
    wish_list_link.click
    ensure_header_loaded
    wish_list_label.should_exist
    len = timeout(1000).wish_list.length
    while len > 0
      wish_list.at(0).remove_button.click
      len-=1
      ensure_header_loaded
    end
  end

#CART CALCULATION OPERATIONS
  # Adds the prices of all items in a shopping cart
  def calculate_cart_total
    $tracer.report("Should #{__method__}.")
    $tracer.trace("GameStopCartFunctions: #{__method__}, Line: #{__LINE__}")
		retry_until_found(lambda{cart_list.exists != false}, 10)
		cart_list.should_exist
    cart = cart_list
    total = BigDecimal.new("0")
    for i in 0..(cart.length)
      cart_item = cart.at(i)
      total += money_string_to_decimal(cart_item.price.innerText)
    end
    return total
  end

  def calculate_pur_discount(discount_total)
    $tracer.report("Should #{__method__}.")
    $tracer.trace("GameStopCartFunctions: #{__method__}, Line: #{__LINE__}")
    #if the discount total array is greater than 0 then return the sum of the array
    discount_sum = discount_total.inject(0, :+)
    $tracer.report("#{__method__} difference is #{discount_sum}")
    return discount_sum
  end

  # calculate_cart_total, cart_subtotal_value and cart_discount are @browser
  def check_cart_subtotal_and_discount(params)
    $tracer.report("Should #{__method__}.")
    $tracer.trace("GameStopCartFunctions: #{__method__}, Line: #{__LINE__}")

    unless params["promo_code_number"].blank?
      add_promo_code(params)
      # TODO: Validate if discount will disappear after removing the coupon
      # TODO: Create a flag to remove a promo code
      remove_promo_code
      add_promo_code(params)
    end

    cart_total = calculate_cart_total
    subtotal = money_string_to_decimal(cart_subtotal_value.inner_text)
    $tracer.trace("Subtotal: " + subtotal.to_f.to_s + " CART TOTAL:::: " + cart_total.to_f.to_s)
    cart_discount_figure = BigDecimal.new("0")
    cart_discount_total = BigDecimal.new("0")
    if subtotal < cart_total
      i=0
      while discount_amount_from_cart.length > i
        cart_discount_figure = money_string_to_decimal(discount_amount_from_cart[i].find.td.innerText)
        cart_discount_total -= cart_discount_figure
        i += 1
      end
    end

    unless cart_discount.exists
      $tracer.trace("Cart total is equal to subtotal.")
      cart_total.should == subtotal
    else
      $tracer.trace("Cart total is greater than subtotal due to discount.")
      cart_total.should > subtotal

      #  discount_type 'percent'
      calculated_cart_discount = cart_total.to_f * 0.10 if params['discount_type'] == "percent"
      #  discount_type 'dollar'
      calculated_cart_discount = (cart_total.to_f > 10 ? 10 : cart_total.to_f) if params['discount_type'] == "dollar"
      $tracer.trace("Assert that the cart discount total is equal to the calculated cart total") if !params["discount_type"].blank?
      cart_discount_total.should == calculated_cart_discount.to_f.round(2) if !params['discount_type'].blank?

      $tracer.trace("Calculated Discount :: #{cart_discount_total.to_f.round(2)}")
      calculated_subtotal = cart_total - cart_discount_total.to_f.round(2)
      $tracer.trace("Calculated Subtotal :: #{calculated_subtotal.to_f.round(2)}    Expected Subtotal :: #{subtotal.to_f} ")
      calculated_subtotal.round(2).should == subtotal
    end

    return subtotal
  end

  def handle_mature_product_screen(params)
    $tracer.trace("GameStopCartFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    wait_for_landing_page_load
    validate_cookies_and_tags(params)
    seventeen_or_older_button.click
  end

end