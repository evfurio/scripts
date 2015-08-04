# encoding: utf-8

# d-Con %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_aow_spec.rb --csv %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_UI_dataset.csv --range AOW01 --browser chrome  --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/WebInStore/dsl/src/dsl"
require "bigdecimal"

$tracer.mode=:on
$tracer.echo=:on
#global_functions passes the csv row object and return the parameters.
$global_functions = GlobalFunctions.new()

$tc_desc = $global_functions.desc
$tc_id = $global_functions.id

describe 'WIS Add On Warranty' do
  before(:all) do
    @browser = WebBrowser.new(browser_type_parameter)
    @browser.delete_internet_files(browser_type_parameter)
    $options.default_timeout = 60_000
    $snapshots.setup(@browser, :all)
		
		#Get the parameters from the csv dataset
    @params = $global_functions.csv
    @sql = $global_functions.sql_file
    @db = $global_functions.db_conn
    @start_page = $global_functions.prop_url.find_value_by_name("url")
		@store_search_svc, @store_search_svc_version = $global_functions.storesearch_svc
  end

  before(:each) do
		@before_env_name, @before_release_id = @browser.get_octopus_release
    $tracer.report("Environment : #{@before_env_name}, Release ID : #{@before_release_id}")
    $tracer.trace("#{@env_name}; #{@release_id}")
    @browser.delete_all_cookies_and_verify
    @session_id = generate_guid
  end

  after(:each) do
    @browser.return_current_url
  end

  after(:all) do
    @after_env_name, @after_release_id = @browser.get_octopus_release
    $tracer.report("Environment : #{@after_env_name}, Release ID : #{@after_release_id}")
    @browser.close_all()
  end

  it "#{$tc_id} #{$tc_desc}" do
		@product_sku, @out_of_stock, @low_stock = @browser.load_test_skus_from_db(@db, @sql.to_s)
    @store_addresses = @store_search_svc.perform_get_all_stores_in_range(@session_id, 'GS_US', 'en-US', @store_search_svc_version, @params["ship_zip"], '10')
    @store = @store_addresses[0].store_number.content
    $tracer.trace("Product Sku from DB :::::  #{@product_sku}")
    $tracer.trace("Store Number :::::  #{@store}")
	    
		@browser.open("#{@start_page}/Checkout/instore/product?store=#{@store}")
		$tracer.trace("Product Sku from csv :::::  #{@params["sku"]}")
	
		@aow_total_on_pdp = 0
    sku_list = @params["sku"].split(",")
		i = 0
    while i < sku_list.length
			@browser.search_field.value = "/#{sku_list[i]}"
      @browser.search_button.should_exist
      @browser.search_button.click
			
			# Search Results page
			@browser.product_search_list.at(0).product_details_button.should_exist
			@browser.product_search_list.at(0).product_details_button.click
			@browser.wait_for_landing_page_load
			@aow_total_on_pdp += add_products_to_cart 
			i += 1
		end

		# Cart page
		i = 0
    cart_calculated_sub_total = 0
		@aow_total_on_cart = 0
    while i < @browser.cart_list.length
      item = @browser.cart_list.at(i)
      item.line_item_title.should_exist
      item.line_item_price.should_exist
      item.delete_button.should_exist
			
			@aow_total_on_cart += item.line_item_price.inner_text.gsub("$", "").to_f unless item.line_item_quantity.exists ###		
      cart_calculated_sub_total += item.line_item_price.inner_text.gsub("$", "").to_f
      i += 1
    end
    # Validate CART 
		@aow_total_on_pdp.should == @aow_total_on_cart
    @browser.subtotal_amount.inner_text.gsub("$","").should == cart_calculated_sub_total.to_s
		@subtotal_on_cart = @browser.subtotal_amount.inner_text.gsub("$","")
		$tracer.trace ("Calculated Cart SubTotal: #{cart_calculated_sub_total.to_s}        Actual Cart SubTotal: #{@subtotal_on_cart}")
		$tracer.trace ("AOW Total on PDP: #{@aow_total_on_pdp}        AOW Total on CART: #{@aow_total_on_cart}")

    @browser.continue_button.click
		@browser.wait_for_landing_page_load
		
		# Shipping Address page
		@browser.search_email_field.value = @params["ship_email"]
		@browser.search_go_button.click
		@browser.wait_for_landing_page_load
				
		@browser.select_customer_button.should_exist
		@browser.select_customer_button.click
		@browser.wait_for_landing_page_load
		
		@browser.continue_button.click
		@browser.wait_for_landing_page_load
		
		# Shipping Address confirmation page
		@browser.shipping_add_addconfm_button.click if @browser.shipping_add_addconfm_button.exists
		@browser.wait_for_landing_page_load
		
		# Handling Options page
		@browser.retry_until_found(lambda{@browser.order_promo_code_field.exists != false}, 10)
		@browser.order_promo_code_field.should_exist
		unless @params["promo_code"] == ''
			@browser.order_promo_code_field.value = @params["promo_code"] 
			@browser.apply_promo_button.click
			@browser.wait_for_landing_page_load
			@browser.order_promo_code.should_exist
		else
			validate_order_details
			@browser.continue_button.click
			@browser.wait_for_landing_page_load
		end
				
		# Order Review page
		validate_order_details
		@browser.continue_button.click
		@browser.wait_for_landing_page_load
		
		# Order Confirmation page
		@browser.bar_code.should_exist
		validate_order_total
		@browser.wait_for_landing_page_load
  end
		
	def add_products_to_cart
		# Product Details page
		@browser.aow_panel.should_exist
    $tracer.trace("AOW Length ::::: #{@browser.aow_service_plans.length} ")
    # $tracer.trace("AOW Plans  ::::: #{@browser.aow_service_plans.available_values} ")

		@browser.aow_service_plans.at(1).aow_price.inner_text == "$4.99"
		aow_on_pdp = @browser.aow_service_plans.at(1).aow_price.inner_text.gsub("$", "").to_f
		@browser.aow_service_plans.at(1).plan_details.click
		@browser.aow_details_back_button.click
		@browser.wait_for_landing_page_load
		# i=0
		# while i < @browser.aow_service_plans.length
			 @browser.aow_service_plans.at(1).click
			# @browser.wait_for_landing_page_load
			# i+=1
		# end
		
		@browser.add_to_cart_button.click
		@browser.wait_for_landing_page_load
		return aow_on_pdp
	end
	
	def validate_order_details
		@browser.subtotal_label.should_exist
		@browser.subtotal_amount.should_exist
		@browser.shipping_method_label.should_exist
		@browser.shipping_method.should_exist
		@browser.shipping_cost.should_exist
		@browser.discount_label.should_exist
		@browser.discount_amount.should_exist
		@browser.sales_tax_label.should_exist
		@browser.sales_tax_amount.should_exist
		@browser.order_total_label.should_exist
		@browser.order_total_amount.should_exist
	end
	
	def validate_order_total
		if @browser.sales_tax_amount.length == 1
			calculated_order_total = @browser.subtotal_amount.inner_text.gsub("$","").to_f + @browser.shipping_cost.inner_text.gsub("$","").to_f - @browser.discount_amount.inner_text.gsub("- $","").to_f + @browser.sales_tax_amount.inner_text.gsub("$","").to_f
		else
			calculated_order_total = @browser.subtotal_amount.inner_text.gsub("$","").to_f + @browser.shipping_cost.inner_text.gsub("$","").to_f - @browser.discount_amount.inner_text.gsub("- $","").to_f + @browser.sales_tax_amount[1].innerText.gsub("$","").to_f
		end
		$tracer.trace("Calculated Order Total ::::: #{calculated_order_total.to_s}        Acual Order Total ::::: #{@browser.order_total_amount.inner_text.gsub("$","")} ")
		# puts @browser.subtotal_amount.inner_text.gsub("$","").to_f
		# puts @browser.shipping_cost.inner_text.gsub("$","").to_f
		# puts @browser.discount_amount.inner_text.gsub("- $","").to_f 
		# puts @browser.sales_tax_amount[1].innerText.gsub("$","").to_f unless @browser.sales_tax_amount.length == 1
	end
	
end


















