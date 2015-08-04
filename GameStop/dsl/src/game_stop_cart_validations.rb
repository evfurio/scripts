# Function Library - Cart

## Functions should include steps that allow a specification to get, add, update, remove, modify information for elements of the targeted SUT/AUT
## No validations should occur in the function library, only transfer of data or interaction with elements/attributes

module GameStopCartValidations

#CART VALIDATION OPERATIONS
#FIXME : Adding this function in for validation efforts.  Not sure it is the correct solution for this validation.  Also needs finders and not hardcoded references to HTML attributes.
  def validate_pur_discount
    $tracer.trace("GameStopCartFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    cart_discount_figure = BigDecimal.new("0")
    cart_discount_total = BigDecimal.new("0")
    cart_pur_pro_total = BigDecimal.new("0")
    if cart_discount.exists
      i=0
      while discount_amount_from_cart.length > i
        #FIXME : This should be a finder
        $tracer.trace("Discount Description : #{discount_amount_from_cart[i].th.strong.innerText}")
        discount_amount_from_cart[i].th.strong.innerText.should include "PowerUp Rewards Pro"
        #FIXME : This should be a finder
        cart_discount_figure = money_string_to_decimal(discount_amount_from_cart[i].find.td.innerText)
        cart_discount_total -= cart_discount_figure
        #FIXME: I don't think this will work in a scenario where we apply a discount first then PUR discount
        # The correct implementation would be to only factor in the discount total for PUR allowed discounts
        cart_pur_pro_total = calculate_cart_total - cart_discount_total
        i += 1
      end
    end
    $tracer.trace("Cart PUR Pro total: #{cart_pur_pro_total}")
    return cart_pur_pro_total
  end

  def validate_paypal_button(params)
    $tracer.trace("GameStopCartFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
		unless params["do_adroll"] || params["do_ispu"]
			retry_until_found(lambda{paypal_chkout_button.exists != false}, 10)
			paypal_chkout_button.should_exist 
		end
  end

  def validate_product_details_in_cart(cart_list, product_title, product_price)
    $tracer.trace("GameStopCartFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    # Assert 1: Validate products from ProductDetails Page against Cart Page
    cart_list.name_link.innerText.should include convert_to_utf8(product_title)
    cart_list.price.innerText.gsub(/[$]/, '').should == product_price
    if cart_list.availability_label.innerText.include?('Pre-order')
      cart_page_availability = 'PR'
    elsif cart_list.availability_label.innerText.include?('Backordered')
      cart_page_availability = 'BO'
    else
      cart_page_availability = 'A'
    end
    return cart_page_availability
  end

  def validate_product_details_in_db(db_result, product_title, product_price, cart_page_availability)
    $tracer.trace("GameStopCartFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    # Assert 2: Validate products against SQL Query Response
    db_result.Title.should include convert_to_utf8(product_title)
    db_result.Price.to_f.round(2).should == product_price.to_f
    db_result.Availability.should == cart_page_availability
  end

  def validate_product_details_in_catalog_svc(catalog_svc, catalog_svc_version, session_id, db_result, product_title, product_price, cart_page_availability)
    $tracer.trace("GameStopCartFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    # Assert 3: Validate products against Catalog Service Response
    catalog_rsp = catalog_svc.perform_get_product_by_sku(catalog_svc_version, session_id, db_result.variantid)
    catalog_rsp.http_body.find_tag("product").at(0).display_name.content.should include convert_to_utf8(product_title)
    catalog_rsp.http_body.find_tag("product").at(0).list_price.content.to_f.round(2).should == product_price.to_f
    catalog_rsp.http_body.find_tag("product").at(0).availability.content.should == cart_page_availability
  end

  def validate_products_in_cart_service(session_id, cart_id, cart_svc, cart_svc_version, product_title, product_price, cart_page_availability, i = nil)
    $tracer.trace("GameStopCartFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    # Assert 4: Validate products against Cart Service Response (for authenticated user)
    $tracer.trace("CARTID acting as OWNERID #{cart_id}")
    cart_rsp = cart_svc.perform_get_cart_and_return_message(session_id, cart_id, 'GS_US', 'en-US', cart_svc_version)
    $tracer.trace(cart_rsp.http_body.formatted_xml)
    if cart_rsp.http_body.find_tag("line_items").at(0).item.at(i).availability.content.include?('BackOrdered')
      cart_svc_availability = 'BO'
    elsif cart_rsp.http_body.find_tag("line_items").at(0).item.at(i).availability.content.include?('PreOrder')
      cart_svc_availability = 'PR'
    else
      cart_svc_availability = 'A'
    end
    cart_rsp.http_body.find_tag("line_items").at(0).item.at(i).display_name.content.should include convert_to_utf8(product_title)
    cart_rsp.http_body.find_tag("line_items").at(0).item.at(i).list_price.content.to_f.round(2).should == product_price.to_f
    cart_svc_availability.should == cart_page_availability
  end

  # Validates the badge overlay on the "Your Cart" button
  def validate_cart_badge(session_id, cart_id, cart_svc, cart_svc_version, params)
    $tracer.trace("GameStopCartFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__} #{params['validate_cart_badge']}.")

    #We'll call to the method but report whether we want to validate this or not.  If not, we'll move on.
    if params['validate_cart_badge']
      #retry_until_found(lambda{self.cart_badge.exists == true})
      sleep 5
      actual_result = (self.cart_badge.call("style.display").eql?("none") ? true : false )
      quantity = nil
      if self.cart_badge.innerText == ""
        actual_result.should == true
        quantity = cart_svc.perform_return_item_quantity_from_cart(session_id, cart_id, 'GS_US', 'en-US', cart_svc_version)
        quantity.should == "0"
      else
        actual_result.should == false
        quantity = cart_svc.perform_return_item_quantity_from_cart(session_id, cart_id, 'GS_US', 'en-US', cart_svc_version)
        # Assertion: Quantity from CART service GetCart operation should be equal to CartBadge innerText
        quantity.should == self.cart_badge.innerText
      end
    end
  end

  # Assert existence of the Certona recommendation cartridge on the cart. We Recommend should exist and there should be 4 items displayed.
  def validate_certona_recommendation
    $tracer.trace("GameStopCartFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    sleep 5
    recommendations_label.should_exist
    recommendations_label.innerText.should == "WE ALSO RECOMMEND"
    $tracer.trace("Number of Recommendations: #{recommendations_list.length}")
    recommendations_list.length.should == 4
  end

  # Assert existence of Upsell Modal
  def validate_upsell_modal
    $tracer.trace("GameStopCartFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    sleep 3

		upsell_modal_popup.should be_visible
		upsell_modal_close_button.should_exist
		upsell_cart_count.should_exist
		upsell_cart_total.should_exist
		upsell_checkout_button.should_exist
		upsell_continue_shopping_link.should_exist
		
		############
		aow_panel.should be_visible
		aow_header.should_exist
		aow_message.should_exist
		
		aow_selected_title.should_not be_visible
		aow_selected_price.should_not be_visible
		
		$tracer.trace("AOW Plans  ::::: #{aow_service_plans.available_values} ")
		i = 0
    while i < aow_service_plans.length
			aow_service_plans.at(i).click
			aow_service_plans.at(i).plan_details.click if aow_service_plans.at(i).plan_details.exists
			@aow_price = aow_service_plans.at(i).aow_price.inner_text if aow_service_plans.at(i).aow_price.exists
			wait_for_landing_page_load
			i += 1
		end

		add_plan_to_cart_button.click
		wait_for_landing_page_load
		
		############
		aow_panel.should_not be_visible
		
		aow_selected_title.should be_visible
		aow_selected_price.should be_visible
		$tracer.trace("Posted AOW: #{aow_selected_price.inner_text}        Selected AOW #{@aow_price}")
		aow_selected_price.inner_text.should == @aow_price
		
    $tracer.report("Upsell Modal is visible for this product.")
    upsell_checkout_button.click
    wait_for_landing_page_load
  end

  def validate_pur_account(pur_number)
    $tracer.trace("GameStopCartFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    if pur_number[0,4] == '3976' || pur_number[0,4] == '3975'
      $tracer.report("First 4 digits of PUR number :: #{pur_number[0,4]}")
      pur_member_inquiry.should_not_exist
      # Please note that there are instances where discount is not available for PUR Pro
      return true
    else
      $tracer.trace("PUR message :: #{pur_member_inquiry.innerText}")
      pur_member_inquiry.innerText.should == 'PowerUp Rewards member?'
      return false
    end
  end

end