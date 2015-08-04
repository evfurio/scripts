# encoding: utf-8
#################################################################################################################################################################################################################################### 
### d-Con %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_checkout_auto_firing_coupon_spec.rb --csv %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_UI_dataset.csv --range TFS49665 --browser chrome --or
#################################################################################################################################################################################################################################### 

require "#{ENV["QAAUTOMATION_SCRIPTS"]}/WebInStore/dsl/src/dsl"

#Get the test ID and description from the CSV to populate the test method.
#This should only apply to data driven test cases using single test method execution.
id_csv = QACSV.new(csv_filename_parameter)
id_row = id_csv.find_row_by_name(csv_range_parameter)
$tc_id = id_row.find_value_by_name("ID")
$tc_desc = id_row.find_value_by_name("TestDescription")
$tc_desc = "Test case description was not found" if $tc_desc == ""

describe "Checkout Auto Firing Coupon" do

  before(:all) do
    @browser = WebInStoreBrowser.new(browser_type_parameter)
    $options.default_timeout = 90_000
    $snapshots.setup(@browser, :all)
    $tracer.mode = :on
    $tracer.echo = :on
  end

  before(:each) do
    @browser.cookie.all.delete
    @params = @browser.get_params_from_csv
    @global_functions = GlobalServiceFunctions.new
    @global_functions.csv = @params["row"]
    @global_functions.parameters
    @sql = @global_functions.sql_file
    @db = @global_functions.db_conn
    @session_id = generate_guid
    @store_search_svc, @store_search_svc_version = @global_functions.storesearch_svc
    @start_page = @global_functions.prop_url.find_value_by_name("url")
    @store_addresses = @store_search_svc.perform_get_all_stores_in_range(@session_id, "GS_US", "en-US", @store_search_svc_version, @params["ship_zip"], 10)
    @store = @store_addresses[0].store_number.content
  end

  after(:each) do
    @browser.return_current_url
    @browser.close_all
  end

  it "#{$tc_id} #{$tc_desc}" do
    url = "#{@start_page}/Checkout/instore/product?store=#{@store}&reg=3"
    @browser.open(url)
    sku = @params["sku"]
    i = 0
    @split_data=sku.split(",")
    @split_data.each { |type|
      @browser.search_field.value = type
      @browser.search_button.should_exist
      @browser.search_button.click
      item = @browser.product_search_list.at(0)
      item.product_details_button.should_exist
      item.product_details_button.click
      if i == 1
        @browser.age_verification_required_label.should_exist
        @browser.age_warning_checkbox.should_exist
        @browser.age_warning_checkbox.click
      end
      @browser.add_to_cart_button.click
      i+=1
    }
    
    @browser.added_to_cart_label.should_exist
    @browser.subtotal_label.should_exist
    @browser.subtotal_amount.should_exist
    @browser.discount_label.should_exist
    @browser.discount_amount.should_exist
    @browser.order_total_label.should_exist
    @browser.order_total_amount.should_exist
    @browser.cart_note.should_exist
    @browser.update_button.should_exist
 
	cart_product_price = @browser.line_item_price.inner_text
	cart_product_qty = @browser.line_item_quantity.value
	cart_subtotal = @browser.subtotal_amount.inner_text.gsub("$", "")
	cart_discount = @browser.discount_amount.inner_text.gsub("$", "")
	cart_total    = @browser.order_total_amount.inner_text.gsub("$", "")
	$tracer.trace("****** Cart List******")
	$tracer.trace("::::::::::::::::::::::::::Product Price #{cart_product_price}")
	$tracer.trace("::::::::::::::::::::::::::Product Quantity #{cart_product_qty}")
	$tracer.trace("::::::::::::::::::::::::::Cart Subtotal #{cart_subtotal}")
	$tracer.trace("::::::::::::::::::::::::::Cart Discount #{cart_discount}")
	$tracer.trace("::::::::::::::::::::::::::Cart Total #{cart_total}"	)	
	cart_calculated_sub_total=0
    i = 0
    while i < @browser.cart_list.length
      item = @browser.cart_list.at(i)
      item.line_item_title.should_exist
      item.line_item_price.should_exist
      item.line_item_quantity.should_exist
      item.line_item_sku.should_exist
      item.delete_button.should_exist
	  $tracer.trace("Line Item Price no. #{i+1}). #{item.line_item_price.inner_text.gsub("$", "").to_f } Quantity : #{item.line_item_quantity.value.to_i} ")
	  cart_calculated_sub_total += item.line_item_price.inner_text.gsub("$", "").to_f 
      i += 1
    end
	#Validating Cart Order Total
	cart_discount=cart_discount.gsub("- ","")
	cart_subtotal.should == @browser.round(cart_calculated_sub_total).to_s
	cart_total.should == @browser.round((cart_subtotal.to_f - cart_discount.to_f)).to_s	
	$tracer.trace ("Calculated Cart Sub Total :#{cart_calculated_sub_total}")
	$tracer.trace("Cart Discount :#{cart_discount.to_f}")
	$tracer.trace("Cart Order Total :#{cart_total}")
	
    @browser.continue_button.should_exist
    @browser.continue_button.click
	#This method consists of Shipping page labels and validations.
	@browser.shipping_information_exist(@params["ship_country"], @params["ship_first_name"], @params["ship_last_name"], @params["ship_addr1"], @params["ship_addr2"], @params["ship_city"], @params["ship_state"], @params["ship_zip"], @params["ship_phone"], @params["ship_email"], @params["is_new"], @params["disable_state"])
    #This method consists of handling option page labels and validations.
	@browser.handling_option_product_review_info

    if @params["submit_order_flag"]
      # @browser.submit_button.click
	  #This method consists of Web Order Confirmation page labels and validations.
      @browser.order_confirm_info
    end
  end

end
