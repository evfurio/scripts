# d-con C:\Dev\QATestProjects\ReCommerce\spec\ReCommerceTestScripts.rb --browser chrome --or

require "../lib/requires"

describe "ReCommerce Test Suite" do

  before(:all) do
    $options.default_timeout = 20000
    @browser = OmniBrowser.new(browser_type_parameter)
    $tracer.mode = :on
    $tracer.echo = :on
    $tracer.trace @browser
    $snapshots.setup(@browser, :all)
    @start_page = "http://qa.recommercepos.testgs.pvt"
    @browser.open("http://qa.recommercepos.testgs.pvt")
  end

  before(:each) do
    @browser.open(@start_page)
    @browser.cookie.all.delete
    OmniBrowser.delete_temporary_internet_files(browser_type_parameter)
    sleep 3
  end

  after(:each) do
    @browser.return_current_url
  end

  after(:all) do
    $tracer.trace("after all")
    @browser.close_all()
  end


  it "should auto complete with results as I type" do
    @browser.search_header.value = 'iphone'
    sleep 2
    @browser.search_autocomplete_results.li[0].a.exists
    sleep 2
  end

  it "should only auto complete with results when I enter three characters or more" do
    @browser.search_header.value = "iph"
    sleep 1
    @browser.search_autocomplete_results.li[0].a.should_exist
    sleep 1
    @browser.search_header.value = "ip"
    sleep 1
    @browser.search_autocomplete_results.is_visible.should == false
  end

  it "should only take Serial Numbers of 5 digits or greater" do
    @browser.dd_serial_field.value = "12345"
    sleep 1

    # TODO: make finder...
    error_msg = ToolTag.new(@browser.span.className("Validator"), __method__, self)
    error_msg.is_visible.should == false

    url = @browser.url
    @browser.dd_trade_button.click
    sleep 1
    url.should == @browser.url
  end

  it "57968 - should check field validation for MEID" do
    @browser.recommerce_logo.should_exist
    @browser.dd_instruction_label.should_exist

    # MEID must be 14 alphanumeric characters in hexadecimal format

    # set meid to 13 characters - error msg
    @browser.dd_meid_field.value = "1234567890123"
    sleep 1
    @browser.dd_imei_field.value = ""
    @browser.rcm_dd_meid_error_label.innerText.should == "This is not an MEID."
    @browser.dd_trade_button.click
    @browser.rcm_dd_meid_error_label.innerText.should == "This is not an MEID."

    # set meid to 15 characters - error msg
    @browser.dd_meid_field.value = ""
    @browser.dd_meid_field.value = "123456789012345"
    sleep 1
    @browser.dd_imei_field.value = ""
    @browser.rcm_dd_meid_error_label.innerText.should == "This is not an MEID."
    @browser.dd_trade_button.click
    @browser.rcm_dd_meid_error_label.innerText.should == "This is not an MEID."

    # set meid to 14 characters - no error
    @browser.dd_meid_field.value = ""
    @browser.dd_meid_field.value = "12345678901234"
    sleep 1
    @browser.dd_imei_field.value = ""
    @browser.rcm_dd_meid_error_label.is_visible.should == false
    @browser.dd_trade_button.get("disabled").should == nil
  end

  it "57969 - should check field validation for IMEI" do
    @browser.recommerce_logo.should_exist
    @browser.dd_instruction_label.should_exist

    # IMEI must be 15 alphanumeric characters and match an algorithm

    # set meid to 14 invalid characters - error msg
    @browser.dd_imei_field.value = "12345678901234"
    sleep 1
    @browser.dd_meid_field.value = ""
    @browser.rcm_dd_imei_error_label.innerText.should == "This is not an IMEI."
    @browser.dd_trade_button.click
    @browser.rcm_dd_imei_error_label.innerText.should == "This is not an IMEI."

    # set meid to 16 invalid characters - error msg
    @browser.dd_imei_field.value = ""
    @browser.dd_imei_field.value = "1234567890123456"
    sleep 1
    @browser.dd_meid_field.value = ""
    @browser.rcm_dd_imei_error_label.innerText.should == "This is not an IMEI."
    @browser.dd_trade_button.click
    @browser.rcm_dd_imei_error_label.innerText.should == "This is not an IMEI."

    # set meid to 15 characters valid matching algorithm - no error
    @browser.dd_imei_field.value = ""
    @browser.dd_imei_field.value = "990002711517209"
    sleep 1
    @browser.dd_meid_field.value = ""
    @browser.rcm_dd_imei_error_label.is_visible.should == false
    @browser.dd_trade_button.get("disabled").should == nil
  end

  it "57970 - should check field validation for Serial Number" do
    @browser.recommerce_logo.should_exist
    @browser.dd_instruction_label.should_exist

    # IMEI must be at least 5 digits

    # set meid to 4 invalid digits - error msg
    @browser.dd_serial_field.value = "1234"
    sleep 1
    @browser.dd_meid_field.value = ""
    @browser.rcm_dd_serial_error_label.innerText.should == "This is not a Serial Number."
    @browser.dd_trade_button.click
    @browser.rcm_dd_serial_error_label.innerText.should == "This is not a Serial Number."

    # set meid to 15 characters valid matching algorithm - no error
    @browser.dd_serial_field.value = ""
    @browser.dd_serial_field.value = "12345"
    sleep 1
    @browser.dd_meid_field.value = ""
    @browser.rcm_dd_serial_error_label.is_visible.should == false
    @browser.dd_trade_button.get("disabled").should == nil
  end

  it "57983 - should validate GoStores link is active" do
    @browser.recommerce_logo.should_exist
    @browser.dd_instruction_label.should_exist

    # click on GoStores link
    @browser.rcm_trades_label_link.should_exist
    @browser.rcm_trades_label_link.click
    @browser.url.should == "http://posgo.babgsetc.pvt/Stores/Default.aspx?tabid=190"
  end

  it "57984 - should validate Device Valuation page" do
    @browser.recommerce_logo.should_exist
    @browser.dd_instruction_label.should_exist

    # search for a product and go to device val. page
    @browser.search_header.value = "iphone"
    sleep 2 # sleep for time to let list populate
    @browser.search_autocomplete_results.li[0].a.should_exist
    @browser.search_autocomplete_results.li[0].a.click

    # validate the tabs exist for device condition
    cond_panel = @browser.rcm_val_condition_panel
    cond_panel.should_exist
    cond_panel.length.should == 4
    cond_panel.find("A - Like New").should_exist
    cond_panel.find("B - Good").should_exist
    cond_panel.find("C - Poor").should_exist
    cond_panel.find("D - Broken").should_exist

    # assign a condition and grade
    cond_tab = cond_panel.find("D - Broken")
    cond_tab.click
    cond_tab.check_all_that_apply_label.innerText.strip.should == "Check all that apply"
    cond_tab.items_included_label.innerText.strip.should == "Items Included"

    checkbox_list0 = cond_tab.check_all_that_apply_list
    checkbox_list1 = cond_tab.items_included_list

    checkbox_list0.find("Water Damage").click
    checkbox_list0.find("Water Damage").innerText.strip.should == "Water Damage"
    sleep 1
    checkbox_list0.find("Extreme Cosmetic Damage").click
    checkbox_list0.find("Extreme Cosmetic Damage").innerText.strip.should == "Extreme Cosmetic Damage"
    sleep 1
    checkbox_list0.find("Broken Buttons / Ports / Camera / Missing Parts").click
    checkbox_list0.find("Broken Buttons / Ports / Camera / Missing Parts").innerText.strip.should == "Broken Buttons / Ports / Camera / Missing Parts"
    sleep 1
    checkbox_list0.find("Cracked Screen / Non Responsive Screen / Dead Pixels").click
    checkbox_list0.find("Cracked Screen / Non Responsive Screen / Dead Pixels").innerText.strip.should == "Cracked Screen / Non Responsive Screen / Dead Pixels"
    sleep 1
    checkbox_list1.find("Dead Battery / Will Not Charge / No Power").click
    checkbox_list1.find("Dead Battery / Will Not Charge / No Power").innerText.strip.should == "Dead Battery / Will Not Charge / No Power"
    sleep 1
    checkbox_list1.find("Sync Cable and/or Wall Charger and/or Original Packaging Included").click
    checkbox_list1.find("Sync Cable and/or Wall Charger and/or Original Packaging Included").innerText.strip.should == "Sync Cable and/or Wall Charger and/or Original Packaging Included"
    sleep 1

    # evaluate valuation cash/credit
    @browser.rcm_val_credit_label.innerText.strip.should == "Recycle"
    @browser.rcm_val_cash_label.innerText.strip.should == "Recycle"

    # enter valid serial number and click 'trade'
    @browser.dd_serial_field.value = "12345"
    @browser.dd_trade_button.click
    @browser.dd_green_banner_panel.should_exist
  end

  it "57984 - should validate condition A for device" do
    @browser.recommerce_logo.should_exist
    @browser.dd_instruction_label.should_exist

    # search for a product and go to device val. page
    @browser.search_header.value = "iphone"
    sleep 2 # sleep for time to let list populate
    @browser.search_autocomplete_results.li[19].a.should_exist
    @browser.search_autocomplete_results.li[19].a.click

    # validate the tabs exist for device condition
    cond_panel = @browser.rcm_val_condition_panel
    cond_panel.should_exist
    cond_panel.length.should == 4
    cond_panel.find("A - Like New").should_exist
    cond_panel.find("B - Good").should_exist
    cond_panel.find("C - Poor").should_exist
    cond_panel.find("D - Broken").should_exist

    # assign condition A
    cond_tab = cond_panel.find("A - Like New")
    cond_tab.click
    # cond_tab.check_all_that_apply_label.innerText.strip.should == "Check all that apply"
    cond_tab.items_included_label.innerText.strip.should == "Items Included"

    # checkbox_list0 = cond_tab.check_all_that_apply_list
    checkbox_list1 = cond_tab.items_included_list

    # evaluate valuation cash/credit
    @browser.rcm_val_credit_label.innerText.strip.should == "$274.00"
    @browser.rcm_val_cash_label.innerText.strip.should == "$219.00"

    # check inclusions/exclusions and validate offer pricing
    checkbox_list1.find("Sync Cable and/or Wall Charger and/or Original Packaging Included").click
    checkbox_list1.find("Sync Cable and/or Wall Charger and/or Original Packaging Included").innerText.strip.should == "Sync Cable and/or Wall Charger and/or Original Packaging Included"
    sleep 1

    # evaluate valuation cash/credit
    @browser.rcm_val_credit_label.innerText.strip.should == "$275.00"
    @browser.rcm_val_cash_label.innerText.strip.should == "$220.00"
  end

  it "57984 - should validate condition B for device" do
    @browser.recommerce_logo.should_exist
    @browser.dd_instruction_label.should_exist

    # search for a product and go to device val. page
    @browser.search_header.value = "iphone"
    sleep 2 # sleep for time to let list populate
    @browser.search_autocomplete_results.li[19].a.should_exist
    @browser.search_autocomplete_results.li[19].a.click

    # validate the tabs exist for device condition
    cond_panel = @browser.rcm_val_condition_panel
    cond_panel.should_exist
    cond_panel.length.should == 4
    cond_panel.find("A - Like New").should_exist
    cond_panel.find("B - Good").should_exist
    cond_panel.find("C - Poor").should_exist
    cond_panel.find("D - Broken").should_exist

    # assign condition B
    cond_tab = cond_panel.find("B - Good")
    cond_tab.click
    # cond_tab.check_all_that_apply_label.innerText.strip.should == "Check all that apply"
    cond_tab.items_included_label.innerText.strip.should == "Items Included"

    # checkbox_list0 = cond_tab.check_all_that_apply_list
    checkbox_list1 = cond_tab.items_included_list

    # evaluate valuation cash/credit
    @browser.rcm_val_credit_label.innerText.strip.should == "$246.50"
    @browser.rcm_val_cash_label.innerText.strip.should == "$197.00"

    # check inclusions/exclusions and validate offer pricing
    checkbox_list1.find("Sync Cable and/or Wall Charger and/or Original Packaging Included").click
    checkbox_list1.find("Sync Cable and/or Wall Charger and/or Original Packaging Included").innerText.strip.should == "Sync Cable and/or Wall Charger and/or Original Packaging Included"
    sleep 1

    # evaluate valuation cash/credit
    @browser.rcm_val_credit_label.innerText.strip.should == "$247.50"
    @browser.rcm_val_cash_label.innerText.strip.should == "$198.00"
  end

  it "57984 - should validate condition C for device" do
    @browser.recommerce_logo.should_exist
    @browser.dd_instruction_label.should_exist

    # search for a product and go to device val. page
    @browser.search_header.value = "iphone"
    sleep 2 # sleep for time to let list populate
    @browser.search_autocomplete_results.li[19].a.should_exist
    @browser.search_autocomplete_results.li[19].a.click

    # validate the tabs exist for device condition
    cond_panel = @browser.rcm_val_condition_panel
    cond_panel.should_exist
    cond_panel.length.should == 4
    cond_panel.find("A - Like New").should_exist
    cond_panel.find("B - Good").should_exist
    cond_panel.find("C - Poor").should_exist
    cond_panel.find("D - Broken").should_exist

    # assign condition B
    cond_tab = cond_panel.find("C - Poor")
    cond_tab.click
    cond_tab.check_all_that_apply_label.innerText.strip.should == "Check all that apply"
    cond_tab.items_included_label.innerText.strip.should == "Items Included"

    checkbox_list0 = cond_tab.check_all_that_apply_list
    checkbox_list1 = cond_tab.items_included_list

    # evaluate valuation cash/credit
    @browser.rcm_val_credit_label.innerText.strip.should == "$161.00"
    @browser.rcm_val_cash_label.innerText.strip.should == "$128.60"

    # check inclusions/exclusions and validate offer pricing
    checkbox_list0.find("Dents, chips, or gaps in the case?").click
    checkbox_list0.find("Dents, chips, or gaps in the case?").innerText.strip.should == "Dents, chips, or gaps in the case?"
    sleep 1

    @browser.rcm_val_credit_label.innerText.strip.should == "$121.00"
    @browser.rcm_val_cash_label.innerText.strip.should == "$88.60"

    # check inclusions/exclusions and validate offer pricing
    checkbox_list0.find("Is there a personal engraving?").click
    checkbox_list0.find("Is there a personal engraving?").innerText.strip.should == "Is there a personal engraving?"
    sleep 1

    @browser.rcm_val_credit_label.innerText.strip.should == "$111.00"
    @browser.rcm_val_cash_label.innerText.strip.should == "$78.60"

    # check inclusions/exclusions and validate offer pricing
    checkbox_list1.find("Sync Cable and/or Wall Charger and/or Original Packaging Included").click
    checkbox_list1.find("Sync Cable and/or Wall Charger and/or Original Packaging Included").innerText.strip.should == "Sync Cable and/or Wall Charger and/or Original Packaging Included"
    sleep 1

    @browser.rcm_val_credit_label.innerText.strip.should == "$112.00"
    @browser.rcm_val_cash_label.innerText.strip.should == "$79.60"
  end

  it "57984 - should validate condition D for device" do
    @browser.recommerce_logo.should_exist
    @browser.dd_instruction_label.should_exist

    # search for a product and go to device val. page
    @browser.search_header.value = "iphone"
    sleep 2 # sleep for time to let list populate
    @browser.search_autocomplete_results.li[19].a.should_exist
    @browser.search_autocomplete_results.li[19].a.click

    # validate the tabs exist for device condition
    cond_panel = @browser.rcm_val_condition_panel
    cond_panel.should_exist
    cond_panel.length.should == 4
    cond_panel.find("A - Like New").should_exist
    cond_panel.find("B - Good").should_exist
    cond_panel.find("C - Poor").should_exist
    cond_panel.find("D - Broken").should_exist

    # assign condition B
    cond_tab = cond_panel.find("D - Broken")
    cond_tab.click
    cond_tab.check_all_that_apply_label.innerText.strip.should == "Check all that apply"
    cond_tab.items_included_label.innerText.strip.should == "Items Included"

    checkbox_list0 = cond_tab.check_all_that_apply_list
    checkbox_list1 = cond_tab.items_included_list

    # evaluate valuation cash/credit
    @browser.rcm_val_credit_label.innerText.strip.should == "$65.00"
    @browser.rcm_val_cash_label.innerText.strip.should == "$39.80"

    # check inclusions/exclusions and validate offer pricing
    checkbox_list0.find("Water Damage").click
    checkbox_list0.find("Water Damage").innerText.strip.should == "Water Damage"
    sleep 1

    @browser.rcm_val_credit_label.innerText.strip.should == "Recycle"
    @browser.rcm_val_cash_label.innerText.strip.should == "Recycle"

    # in this case - uncheck water damage
    checkbox_list0.find("Water Damage").click
    checkbox_list0.find("Water Damage").innerText.strip.should == "Water Damage"
    sleep 1

    @browser.rcm_val_credit_label.innerText.strip.should == "$65.00"
    @browser.rcm_val_cash_label.innerText.strip.should == "$39.80"

    # check inclusions/exclusions and validate offer pricing
    checkbox_list0.find("Extreme Cosmetic Damage").click
    checkbox_list0.find("Extreme Cosmetic Damage").innerText.strip.should == "Extreme Cosmetic Damage"
    sleep 1

    @browser.rcm_val_credit_label.innerText.strip.should == "$35.00"
    @browser.rcm_val_cash_label.innerText.strip.should == "$9.80"

    # check inclusions/exclusions and validate offer pricing
    checkbox_list0.find("Broken Buttons / Ports / Camera / Missing Parts").click
    checkbox_list0.find("Broken Buttons / Ports / Camera / Missing Parts").innerText.strip.should == "Broken Buttons / Ports / Camera / Missing Parts"
    sleep 1

    @browser.rcm_val_credit_label.innerText.strip.should == "$5.00"
    @browser.rcm_val_cash_label.innerText.strip.should == "Recycle"

    # check inclusions/exclusions and validate offer pricing
    checkbox_list0.find("Cracked Screen / Non Responsive Screen / Dead Pixels").click
    checkbox_list0.find("Cracked Screen / Non Responsive Screen / Dead Pixels").innerText.strip.should == "Cracked Screen / Non Responsive Screen / Dead Pixels"
    sleep 1

    @browser.rcm_val_credit_label.innerText.strip.should == "Recycle"
    @browser.rcm_val_cash_label.innerText.strip.should == "Recycle"

    # check inclusions/exclusions and validate offer pricing
    checkbox_list1.find("Dead Battery / Will Not Charge / No Power").click
    checkbox_list1.find("Dead Battery / Will Not Charge / No Power").innerText.strip.should == "Dead Battery / Will Not Charge / No Power"
    sleep 1

    @browser.rcm_val_credit_label.innerText.strip.should == "$35.00"
    @browser.rcm_val_cash_label.innerText.strip.should == "$9.80"

    # check inclusions/exclusions and validate offer pricing
    checkbox_list1.find("Sync Cable and/or Wall Charger and/or Original Packaging Included").click
    checkbox_list1.find("Sync Cable and/or Wall Charger and/or Original Packaging Included").innerText.strip.should == "Sync Cable and/or Wall Charger and/or Original Packaging Included"
    sleep 1

    @browser.rcm_val_credit_label.innerText.strip.should == "$36.00"
    @browser.rcm_val_cash_label.innerText.strip.should == "$10.80"
  end

end