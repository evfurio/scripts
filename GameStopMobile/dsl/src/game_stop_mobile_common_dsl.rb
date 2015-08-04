module GameStopMobileCommonDSL

  def add_products_to_cart(results_from_file, start_page, params)
    $tracer.trace("GameStopMobileCommonDSL : #{__method__}, Line : #{__LINE__}")

    matured_product = false
    physical_product = false
    results_from_file.each_with_index do |item, i|
      physical_product = (item.condition.eql?("Digital") ? false : true) if !physical_product #condition is case sensitive
      matured_product = (item.esrbrating.eql?("M") ? true : false) if !matured_product # esrbrating is case sensitive
      open("#{start_page}/Catalog/Product/#{item.ProductID}")
      validate_analytics(params)
      product_price_list.at(0).add_to_cart_button.click
      wait_for_landing_page_load
      if i < (results_from_file.count - 1)
        open(start_page)
      end
    end
    return matured_product, physical_product
  end

  def update_products_quantity()
    $tracer.trace("GameStopMobileCommonDSL : #{__method__}, Line : #{__LINE__}")
    if line_item_label.length == 3
      #TFS47460 | TFS47461
      edit_cart_link.click
      wait_for_landing_page_load
      qty_update_field.at(0).value = "2"
      qty_update_field.at(1).value = "2"
      cart_edit_done_link.click
      wait_for_landing_page_load
      line_item_label.should_exist
      qty_update_field.at(0).value.should == "2"
      qty_update_field.at(1).value.should == "2"
      sleep 2
      #TFS47451
      remove_item_link.at(1).click
      wait_for_landing_page_load
      line_item_label.length.should == 2
      #TFS47458
      empty_new_cart
    else
      #TFS47459
      edit_cart_link.click
      wait_for_landing_page_load
      qty_update_field.value = "2"
      cart_edit_done_link.click
      wait_for_landing_page_load
      line_item_label.should_exist
      qty_update_field.value.should == "2"
      sleep 2
      #TFS47457
      empty_new_cart
    end
  end

  def validate_pur(params)
    $tracer.trace("GameStopMobileCommonDSL : #{__method__}, Line : #{__LINE__}")
    powerup_reward_field.value = params["pur"] if powerup_reward_field.value == ""
    if powerup_reward_field.value != ""
      $tracer.trace("PowerUp Rewards Entry")
      promotion_code_apply_button.click
      wait_for_landing_page_load
      if params["valid_pur_svs_cc"]
        $tracer.trace("Valid PUR number.")
        # This doesn't show up anymore for guest...
        unless params["login"] == ""
          @expected_result = true
          actual_result = (powerup_reward_confirm_label.call("style.display").eql?("block") ? true : false)
          actual_result.should == @expected_result
        end
      else
        $tracer.trace("Please enter a valid PUR number.")
        confirm_pur_number_warning
      end
    end
  end

  def validate_svs(params)
    $tracer.trace("GameStopMobileCommonDSL : #{__method__}, Line : #{__LINE__}")
    if not params["valid_pur_svs_cc"]
      $tracer.trace("Please enter a valid credit card number.")
      confirm_invalid_gc_warning
    end
  end

  #Validates the javascript if set to true in csv
  # REFACTOR : What does this really do?  Why are we wrapping a method with a case statement?
  def validate_analytics(params)
    $tracer.trace("GameStopMobileCommonDSL : #{__method__}, Line : #{__LINE__}")
    case true
      when params["do_google_analytics"]
        validate_google_analytics_code
      when params["do_pixel_validate"]
        validate_visit_pixel_script
    end
  end

  #Checks if google_analytics code exists
  def validate_google_analytics_code
    $tracer.trace("GameStopMobileCommonDSL : #{__method__}, Line : #{__LINE__}")
    google_analytics_code = "
           var accountNumber = 'UA-10897913-11';
           var _gaq = _gaq || [];
           _gaq.push(['_setAccount', accountNumber]);
           _gaq.push(['_trackPageview']);

           (function () {
               var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
               ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
               var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
           })();
"
		google_analytics_script.should include google_analytics_code
	end

	
	def paypal_sandbox_login
    $tracer.trace("GameStopCheckoutFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
		retry_until_found(lambda{paypal_test_acct_login_field.exists != false}, 10)
    paypal_test_acct_login_field.value = "davidturner@gamestop.com"
    paypal_test_acct_password_field.value = "4baV239056"
	  paypal_test_acct_login_button.click
	  sleep 3
  end

  #Checks if visit pixel script exists
  def validate_visit_pixel_script
    pixel = visit_pixel_script.innerText
    pixel.should include "var _caq = _caq || [];"
    pixel.should include "(function () {"
    pixel.should include "var ca = document.createElement(\"script\");"
    pixel.should include "ca.type = \"text/javascript\";"
    pixel.should include "ca.async = true;"
    pixel.should include "ca.id = \"_casrc\";"
    pixel.should include "ca.src"
    pixel.should include "var ca_script = document.getElementsByTagName(\"script\")[0];"
    pixel.should include "ca_script.parentNode.insertBefore(ca, ca_script);"
    pixel.should include "})();"
  end

  # Returns the visit pixel script for PowerUp Rewards page
  def visit_pixel_script_powerup
    $tracer.trace(__method__)
    return ToolTag.new(div.className("/ui-content ui-body-c/").script, __method__, self)
  end
end
