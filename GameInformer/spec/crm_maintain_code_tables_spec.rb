#USAGE NOTES#
# this script is for the CRM Reports
# all methods are associated with a manual test case in MTM
# GameInformer project/Regression Tests plan

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameInformer/dsl/src/dsl"


describe "CRM Maintain Code Tables" do

  before(:all) do
    $options.default_timeout = 20_000
    $browser = GameInformerBrowser.new(browser_type_parameter)
    $tracer.mode = :on
    $tracer.echo = :on
    # $tracer.trace $browser
    $snapshots.setup($browser, :all)
    GameInformerBrowser.delete_temporary_internet_files(browser_type_parameter)
    @start_page = "http://qa.crm.gameinformer.com/"

  end

  before(:each) do
    $browser.open(@start_page)
    $browser.cookie.all.delete

    # Log in.
    $username = "402172"
    $password = "Chrisqatest!"
    $browser.login_user_crm($username, $password)

  end

  after(:each) do
    $browser.log_off_link.click
  end

  after(:all) do
    $browser.close_all()
  end

  # Declare variables for this test:

  it "should select maintain code tables from dropdown" do

    $browser.create_maintenance_menu_list.at(1).innerText.strip.should == "Maintain Code Tables"
    $browser.create_maintenance_menu_list.at(1).click
  end

  it "should verify maintain code tables page" do
    $browser.create_maintenance_menu_list.at(1).click
    $browser.code_tables_label.should_exist
    $browser.code_tables_label.innerText.strip.should == "Maintain Code Tables"

    $browser.code_tables_subscription_title_link.should_exist
    $browser.code_tables_media_type_link.should_exist
    $browser.code_tables_issue_link.should_exist
    $browser.code_tables_item_code_link.should_exist
    $browser.code_tables_cancel_reason_type_link.should_exist
    $browser.code_tables_comp_reason_type_link.should_exist
    $browser.code_tables_country_link.should_exist
    $browser.code_tables_state_link.should_exist
    $browser.code_tables_media_type_link.should_exist
    $browser.code_tables_zip_code_link.should_exist
    $browser.code_tables_app_settings_link.should_exist
  end

  it "should verify subscription title management page" do
    $browser.create_maintenance_menu_list.at(1).click
    $browser.code_tables_subscription_title_link.click
    $browser.maintain_code_tables_child_page_label.should_exist
    #This will need to be updated once the title has been fixed; currently misspelled.
    $browser.maintain_code_tables_child_page_label.innerText.strip.should == "Subscription Title Managment"
    $browser.subscription_digital_management_title.should_exist
    $browser.subscription_digital_print_title.should_exist
    $browser.subscription_title_column.innerText.strip.should == "Title"
    $browser.maintain_code_tables_media_type_column.innerText.strip.should == "Media Type"
    $browser.subscription_subscriber_button.should_exist

  end

  it "should verify media type management page" do
    $browser.create_maintenance_menu_list.at(1).click
    $browser.code_tables_media_type_link.click
    $browser.maintain_code_tables_child_page_label.innerText.strip.should == "Media Type Management"
    $browser.media_type_print_title.should_exist
    $browser.media_type_digital_title.should_exist
    $browser.maintain_code_tables_media_type_column.innerText.strip.should == "Media Type Name"
    $browser.media_type_add_button.should_exist

  end

  it "should verify issue management page" do
    $browser.create_maintenance_menu_list.at(1).click
    $browser.code_tables_issue_link.click
    $browser.maintain_code_tables_child_page_label.innerText.strip.should == "Issue Management"
    $browser.issue_management_title_column.innerText.strip.should == "Title [Media Type]"
    $browser.issue_management_sku_num_column.innerText.strip.should == "SKU #"
    $browser.issue_management_issue_num_column.innerText.strip.should == "Issue #"
    $browser.issue_management_volume_num_column.innerText.strip.should == "Volume #"
    $browser.issue_management_year_num_column.innerText.strip.should == "Year"
    $browser.issue_management_month_num_column.innerText.strip.should == "Month"
    $browser.issue_management_on_sale_column.innerText.strip.should == "On Sale"
    $browser.issue_management_cut_off_column.innerText.strip.should == "Cut Off"
    $browser.issue_management_seq_column.innerText.strip.should == "Seq"
    $browser.issue_management_view_button.should_exist
    $browser.issue_management_add_issue_button.should_exist


  end

  it "should verify item code page" do
    $browser.create_maintenance_menu_list.at(1).click
    $browser.code_tables_item_code_link.click
    $browser.item_code_management_label.innerText.strip.should == "Item Code Management"
    $browser.item_code_items_filter_picker_field.should_exist
    $browser.item_code_items_types_picker_field.should_exist
    $browser.item_code_management_itemcode_column.innerText.strip.should == "ItemCode"
    $browser.item_code_management_title_column.innerText.strip.should == "Title"
    $browser.item_code_management_mediatype_column.innerText.strip.should == "Media Type"
    $browser.item_code_management_subscriptiontype_column.innerText.strip.should == "Subscription Type"
    $browser.item_code_management_issues_column.innerText.strip.should == "Issues"
    $browser.item_code_management_price_column.innerText.strip.should == "Price"
    $browser.item_code_management_search_button.should_exist
    $browser.item_code_management_add_button.should_exist
  end


end