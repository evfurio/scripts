# d-con C:\dev\QAAutomationScripts\GameStop\spec\Profile\gs_profile_smoke.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\Profile\profile_dataset.csv --range TFS74063 --browser chrome --or -e 'TFS74063 should create an account'
# d-con C:\dev\QAAutomationScripts\GameStop\spec\Profile\gs_profile_smoke.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\Profile\profile_dataset.csv --range TFS74064 --browser chrome --or -e 'TFS74064 should login with existing account'
# d-con C:\dev\QAAutomationScripts\GameStop\spec\Profile\gs_profile_smoke.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\Profile\profile_dataset.csv --range TFS74065 --browser chrome --or -e 'TFS74065 should update Personal Info'
# d-con C:\dev\QAAutomationScripts\GameStop\spec\Profile\gs_profile_smoke.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\Profile\profile_dataset.csv --range TFS74066 --browser chrome --or -e 'TFS74066 should add an address'
# d-con C:\dev\QAAutomationScripts\GameStop\spec\Profile\gs_profile_smoke.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\Profile\profile_dataset.csv --range TFS74067 --browser chrome --or -e 'TFS74067 should update existing address'
# d-con C:\dev\QAAutomationScripts\GameStop\spec\Profile\gs_profile_smoke.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\Profile\profile_dataset.csv --range TFS74068 --browser chrome --or -e 'TFS74068 should delete existing address'
# d-con C:\dev\QAAutomationScripts\GameStop\spec\Profile\gs_profile_smoke.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\Profile\profile_dataset.csv --range TFS74069 --browser chrome --or -e 'TFS74069 should add a home store'
require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"
require 'timeout'

$tracer.mode = :on
$tracer.echo = :on

# global_functions passes the csv row object and return the parameters.
$global_functions = GlobalFunctions.new()

$tc_desc = $global_functions.desc
$tc_id = $global_functions.id

describe "GameStop Profile Smoke" do

	before(:all) do
		@browser = WebBrowser.new(browser_type_parameter)
		@browser.delete_internet_files(browser_type_parameter)
		$options.default_timeout = 10_000
		$snapshots.setup(@browser, :all)

		#Get the parameters from the csv dataset
		@params = $global_functions.csv
		@login = $global_functions.login
		@password = $global_functions.password
		@start_page = $global_functions.prop_url.find_value_by_name("url")
	end

	before(:each) do
		@browser.delete_all_cookies_and_verify
		@browser.open(@start_page)
		@browser.log_in_link.click
		@browser.wait_for_landing_page_load
	end

	after(:each) do
		@browser.return_current_url
	end

	after(:all) do
		@browser.close_all()
	end
	
	it "TFS74063 should create an account" do
		@email = auto_generate_username(nil, "@gspcauto.fav.cc","otto_")
		@new_password = $global_functions.password_generator(10)
    $tracer.report("Email Address: #{@email}, Password: #{@new_password}")
		
    @browser.login_header_label.should_exist
    @browser.create_an_account_button.click
    @browser.create_user_header_label.should_exist
    @browser.email_opt_in_checkbox.is_visible.should be_true
    @browser.create_email_address_field.value = @email
    @browser.create_password_field.value = @new_password
    @browser.confirm_password_field.value = @new_password
    @browser.email_opt_in_checkbox.click
    @browser.submit_button.click
    sleep 5
    @browser.my_account_link.click
    @browser.wait_for_landing_page_load
    @browser.personal_info_label.should_exist
    @browser.profile_logout_link.click
  end

  it "TFS74064 should login with existing account" do
    @browser.login_header_label.should_exist
    @browser.remember_me_checkbox.is_visible.should be_true
    @browser.email_address_field.value = @login
    @browser.password_field.value = @password
		$tracer.report("Email Address: #{@login}, Password: #{@password}")
    @browser.log_in_button.click
    sleep 5
    $tracer.trace("URL: " + @browser.url)
    @browser.url.should == @start_page+'/'
    @browser.my_account_link.click
    @browser.wait_for_landing_page_load
		
    @browser.personal_info_label.should_exist
    @browser.profile_logout_link.click
  end

  it "TFS74065 should update Personal Info" do
		@browser.login_header_label.should_exist
    @browser.remember_me_checkbox.is_visible.should be_true
    @browser.email_address_field.value = @login
    @browser.password_field.value = @password
		$tracer.report("Email Address: #{@login}, Password: #{@password}")
    @browser.log_in_button.click
    sleep 5
    $tracer.trace("URL: " + @browser.url)
    @browser.url.should == @start_page+'/'
    @browser.my_account_link.click
    @browser.wait_for_landing_page_load
		
    @browser.personal_info_label.should_exist
		@browser.personal_details_edit_link.click
		@browser.wait_for_landing_page_load
		
    @browser.username_label.innerText.should == @params["login"]
    @browser.password_label.is_visible.should be_true
    @browser.contact_email_field.is_visible.should be_false
    @browser.contact_primary_phone_field.value = @params["phone_number"]
    @browser.pur_security_question_selector.is_visible.should be_false
    @browser.pur_security_answer_field.is_visible.should be_false
    @browser.birth_month_selector.value = @params["birth_month"]
    @browser.birth_day_selector.value = @params["birth_day"]
    @browser.gender_buttons.value = @params["gender"]
    @browser.personal_info_save_button.click
    @browser.wait_for_landing_page_load
    @browser.personal_info_success_label.is_visible.should be_true
    @browser.profile_logout_link.click
    @browser.wait_for_landing_page_load
  end

  it "TFS74066 should add an address" do
    @browser.login_header_label.should_exist
    @browser.remember_me_checkbox.is_visible.should be_true
    @browser.email_address_field.value = @login
    @browser.password_field.value = @password
		$tracer.report("Email Address: #{@login}, Password: #{@password}")
    @browser.log_in_button.click
    sleep 5
    $tracer.trace("URL: " + @browser.url)
    @browser.url.should == @start_page+'/'
    @browser.my_account_link.click
    @browser.wait_for_landing_page_load
		
    @browser.addresses_link.click
    @browser.address_book_header_label.should_exist
    @browser.shipping_address_panel.address_header_label.should_exist
    @browser.shipping_address_panel.add_address_button.click

    @browser.popup_address_panel.popup_address_label.should_exist
    @browser.popup_address_panel.name_label.should_exist
    @browser.popup_address_panel.first_name_field.value = @params["first_name"]
    @browser.popup_address_panel.last_name_field.value = @params["last_name"]
    @browser.popup_address_panel.address_label.should_exist
    @browser.popup_address_panel.address_1_field.value = @params["addr_line1"]
    @browser.popup_address_panel.address_2_field.should_exist
    @browser.popup_address_panel.city_field.value = @params["city"]
    @browser.popup_address_panel.state_province_selector.value = @params["state"]
    @browser.popup_address_panel.state_province_field.is_visible.should be_false
    @browser.popup_address_panel.zip_postal_code_field.value = @params["postal_code"]
		@browser.popup_address_panel.country_selector.value.should == @params["country"]
    @browser.popup_address_panel.phone_number_label.should_exist
    @browser.popup_address_panel.phone_number_field.value = @params["phone_number"]
    @browser.popup_address_panel.cancel_button.should_exist
    @browser.popup_address_panel.save_button.click
		@browser.wait_for_landing_page_load
		
    @browser.shipping_address_panel.address_list.at(0).full_address_label.should_exist
    $tracer.trace(@browser.shipping_address_panel.address_list.at(0).full_address_label.innerText)
    @browser.shipping_address_panel.address_list.at(0).default_address_label.is_visible.should be_true
    @browser.profile_logout_link.click
    @browser.wait_for_landing_page_load
  end

  it "TFS74067 should update existing address" do
    @browser.login_header_label.should_exist
    @browser.remember_me_checkbox.is_visible.should be_true
    @browser.email_address_field.value = @login
    @browser.password_field.value = @password
		$tracer.report("Email Address: #{@login}, Password: #{@password}")
    @browser.log_in_button.click
    sleep 5
    $tracer.trace("URL: " + @browser.url)
    @browser.url.should == @start_page+'/'
    @browser.my_account_link.click
    @browser.wait_for_landing_page_load
		
    @browser.addresses_link.click
		@browser.wait_for_landing_page_load
    @browser.address_book_header_label.should_exist
    @browser.shipping_address_panel.address_header_label.should_exist
    @browser.shipping_address_panel.address_list.length == 1
    @browser.shipping_address_panel.address_list.at(0).edit_address_button.click
    @browser.wait_for_landing_page_load
    @browser.popup_address_panel.popup_address_label.innerText.should == "Edit Address"

    @browser.popup_address_panel.first_name_field.value = @params["first_name"]
    @browser.popup_address_panel.last_name_field.value = @params["last_name"]
    @browser.popup_address_panel.country_selector.value = @params["country"]
    @browser.popup_address_panel.address_1_field.value = @params["addr_line1"]
    @browser.popup_address_panel.city_field.value = @params["city"]
    @browser.popup_address_panel.state_province_selector.is_visible.should be_false
    @browser.popup_address_panel.state_province_field.value = @params["state"]
    @browser.popup_address_panel.zip_postal_code_field.value = @params["postal_code"]
    @browser.popup_address_panel.phone_number_field.value = @params["phone_number"]
    @browser.popup_address_panel.save_button.click
    @browser.wait_for_landing_page_load
		
    @browser.shipping_address_panel.address_list.at(0).full_address_label.should_exist
		@browser.shipping_address_panel.address_list.at(0).full_address_label.innerText.should == "#{@params["first_name"]} #{@params["last_name"]}#{@params["addr_line1"]}#{@params["city"]}, #{@params["state"]} #{@params["postal_code"]}#{@params["country_code"]}#{@params["phone_number"]}"
    $tracer.trace(@browser.shipping_address_panel.address_list.at(0).full_address_label.innerText)
    @browser.profile_logout_link.click
    @browser.wait_for_landing_page_load
  end

  it "TFS74068 should delete existing address" do
    @browser.login_header_label.should_exist
    @browser.remember_me_checkbox.is_visible.should be_true
    @browser.email_address_field.value = @login
    @browser.password_field.value = @password
		$tracer.report("Email Address: #{@login}, Password: #{@password}")
    @browser.log_in_button.click
    sleep 5
    $tracer.trace("URL: " + @browser.url)
    @browser.url.should == @start_page+'/'
    @browser.my_account_link.click
    @browser.wait_for_landing_page_load
		
    @browser.addresses_link.click
		@browser.wait_for_landing_page_load
    @browser.address_book_header_label.should_exist
    @browser.shipping_address_panel.address_header_label.should_exist
    @browser.shipping_address_panel.address_list.length == 1
    $tracer.trace("Length with address: " +  @browser.shipping_address_panel.address_list.length.to_s)
    @browser.shipping_address_panel.address_list.at(0).delete_address_button.click
		@browser.wait_for_landing_page_load
		
    # Checking to see if the page is disabled
    @browser.overlay_panel.is_visible.should be_true
    @browser.wait_for_landing_page_load
    @browser.popup_remove_confirm_panel.remove_cancel_button.should_exist
    @browser.popup_remove_confirm_panel.remove_submit_button.click
    @browser.wait_for_landing_page_load
    @browser.profile_logout_link.click
		@browser.wait_for_landing_page_load
  end

  it "TFS74069 should add a home store" do
    @browser.login_header_label.should_exist
    @browser.remember_me_checkbox.is_visible.should be_true
    @browser.email_address_field.value = @login
    @browser.password_field.value = @password
		$tracer.report("Email Address: #{@login}, Password: #{@password}")
    @browser.log_in_button.click
    sleep 5
    $tracer.trace("URL: " + @browser.url)
    @browser.url.should == @start_page+'/'
    @browser.my_account_link.click
    @browser.wait_for_landing_page_load
		
    @browser.addresses_link.click
		@browser.wait_for_landing_page_load
    @browser.address_book_header_label.should_exist
    @browser.stores_panel.store_header_label.should_exist
    @browser.stores_panel.add_store_button.click
    @browser.wait_for_landing_page_load
		
    # Checking to see if the page is disabled
    @browser.overlay_panel.is_visible.should be_true
    @browser.store_finder_panel.store_finder_header_label.should_exist
    @browser.store_finder_panel.store_finder_field.value = @params["postal_code"]
    @browser.store_finder_panel.find_stores_button.click
    @browser.wait_for_landing_page_load
    @browser.store_finder_panel.store_results_list.at(0).add_store_button.click
    @browser.wait_for_landing_page_load

    @browser.stores_panel.stores_list.length == 1
    @browser.stores_panel.stores_list.at(0).full_store_label.should_exist
    $tracer.trace("Store added: " +  @browser.stores_panel.stores_list.at(0).full_store_label.innerText)
    @browser.stores_panel.stores_list.at(0).home_store_label.is_visible.should be_true

    @browser.stores_panel.add_store_button.click
    @browser.wait_for_landing_page_load
    @browser.store_finder_panel.store_results_list.at(0).added_store_label.is_visible.should be_true
    @browser.store_finder_panel.store_finder_cancel_button.click
		@browser.wait_for_landing_page_load
    @browser.profile_logout_link.click
		@browser.wait_for_landing_page_load
  end
	
end
