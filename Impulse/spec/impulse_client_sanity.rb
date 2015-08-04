require "#{ENV['QAAUTOMATION_SCRIPTS']}/Impulse/dsl/src/dsl"

# describe "test script" do

    # before(:all) do
		       
        # @browser = ImpulseBrowser.new(browser_type_parameter)
        
        # $snapshots.setup(@browser, :all)
        # $tracer.mode = :on
        # $tracer.echo = :on
    # end
	
    # after(:all) do
        # $tracer.trace("after :all")
        # @browser.close_all
    # end
	
	# # Validating Home page displays - main header items
	# it "WEB - should have a proper header and footer" do
		# @browser.browser(0).open("http://qa1.www.impulsedriven.com")
		# @browser.browser(0).gamestop_logo_link.click
		# @browser.browser(1).url.should == 'http://www.gamestop.com/'
		# $tracer.trace(@browser.browser(1).url)
		
	# end

# end

describe "Impulse Client Smoke Spec" do
  before(:all) do
    @default_timeout = 60000
    $tracer.echo = :on
    # @client = ImpulseClient.new("C:/gs_client_chromium/GamestopClient/cefhost/Development")
	@client = ImpulseClient.new
    $snapshots.setup_app(@client)
    @client.open
    # @client.log_in_as_user("ottomatin@gmail.com", "Manh0le1")
	@client.log_in_as_user("ottomatin@gspcauto.fav.cc", "Manh0le1")
  end

  before(:each) do
    ImpulseClient.default_timeout = @default_timeout
    @client.nav_bar.gamestop_logo.link.click
    @client.store_frame.featured_games_list.should_exist
  end
  
  after(:all) do
    Win32::Screenshot::Take.of(:desktop).write(get_results_directory_name + "/final_snap.png")
    @client.close
  end

  it "should have the expected nav bar components" do
    logo = @client.nav_bar.gamestop_logo
    store = @client.nav_bar.store
    browse = @client.nav_bar.browse
    # forums = @client.nav_bar.forums
    my_games = @client.nav_bar.my_games

    $tracer.trace("checking gamestop_logo")
    logo.link.click
    store.is_selected.should be_true
    browse.is_selected.should be_false
    # forums.is_selected.should be_false
    my_games.is_selected.should be_false
    @client.store_frame.featured_games_list.should_exist

    $tracer.trace("checking store")
    store.link.inner_text.should == "Store"
    store.link.click
    store.is_selected.should be_true
    browse.is_selected.should be_false
    # forums.is_selected.should be_false
    my_games.is_selected.should be_false
    @client.store_frame.featured_games_list.should_exist

    $tracer.trace("checking browse")
    browse.link.inner_text.should == "Browse"
    browse.link.click
    store.is_selected.should be_false
    browse.is_selected.should be_true
    # forums.is_selected.should be_false
    my_games.is_selected.should be_false
    @client.browse_frame.product_list.should_exist
    
    # $tracer.trace("checking forums")
    # forums.link.inner_text.should == "Forums"
    # forums.link.click
    # store.is_selected.should be_false
    # browse.is_selected.should be_false
    # # forums.is_selected.should be_true
    # my_games.is_selected.should be_false
    # @client.forums_frame.forums_my_account_link.should_exist

    $tracer.trace("checking my_games")
    my_games.link.inner_text.should == "My Games"
    my_games.link.click
    store.is_selected.should be_false
    browse.is_selected.should be_false
    # forums.is_selected.should be_false
    my_games.is_selected.should be_true
    @client.my_games_list.should_exist

  end

  it "should have expected help menu components" do
    help_menu = @client.help_menu
    help_menu.should_exist
    help_menu.length.should == 3

    help_menu.support_link.inner_text.should == "Support"
    help_menu.support_link.click
    @client.store_frame.support_label.should_exist
    
    help_menu.about_link.inner_text.should == "About"
    help_menu.about_link.click
    @client.about_window.wait_for_open
    @client.about_window.close
    @client.about_window.wait_for_close

    help_menu.troubleshooting_link.inner_text.should == "Troubleshooting..."
    # Note: not checking click behavior for troubleshooting link because
    # of the "run as admin" popup situation.
  end

  it "should have expected settings menu components" do
    settings_menu = @client.settings_menu
    settings_menu.length.should == 7
    
    settings_menu.settings_link.inner_text.should == "Settings..."
    settings_menu.settings_link.click
    @client.settings_window.wait_for_open
    @client.settings_window.close
    @client.settings_window.wait_for_close

    settings_menu.view_promotions_link.inner_text.should == "View Promotions"

    settings_menu.change_log_in_link.inner_text.should == "Change log-in..."
    settings_menu.change_log_in_link.click
    @client.login_window.wait_for_open
    @client.login_window.close
    @client.login_window.wait_for_close

    settings_menu.restore_archive_link.inner_text.should == "Restore archive..."
    settings_menu.restore_archive_link.click
    @client.restore_archive_window.wait_for_open
    @client.restore_archive_window.close
    @client.restore_archive_window.wait_for_close

    settings_menu.detect_application_link.inner_text.should == "Detect application"
    settings_menu.detect_application_link.click
    @client.detect_application_window.wait_for_open
    @client.detect_application_window.close
    @client.detect_application_window.wait_for_close

    settings_menu.private_server_link.inner_text.should == "Private server \xE2\x9C\x93"

    settings_menu.exit_link.inner_text.should == "Exit"

  end

  it "should have proper My Games behavior" do
    @client.nav_bar.my_games.link.click
    @client.my_games_list.should_exist
    game = @client.my_games_list.at(0)
    game.install_button.inner_text.should == "Install"
    # game.archive_button.inner_text.should == "archive"
    game.product_code_button.inner_text.should == "Product Code"
    game.more_info_button.inner_text.should == "More Info"
    name = game.name_label.inner_text

    game.more_info_button.click
    @client.store_frame.product_header_label.inner_text.should start_with name

    @client.nav_bar.my_games.link.click
    @client.my_games_list.should_exist
  end

  it "should purchase a game" do
    # Click view cart twice due to a bug on the website. If you only click
    # it once, it looks like the cart is empty regardless of whether or not
    # there's stuff in it.
    @client.view_cart_button.click
    @client.view_cart_button.click

    # Empty the cart. This needs to be rolled into the common Impulse
    # empty_cart DSL at some point.
    len = @client.store_frame.cart_list.length
    while len > 0
      @client.store_frame.cart_list.at(0).remove_link.click
      len-=1
    end
    
    @client.search_field.value = "sorceress"
    @client.search_field.press_enter

    @client.store_frame.product_list.at(0).product_title_link.click
    @client.store_frame.add_to_cart_button.click

    field = @client.store_frame.cart_pur_number_field
    if field.exists
      field.value = "3876223441114"
      @client.store_frame.cart_pur_save_button.click
      @client.store_frame.cart_pur_saved_label.should_exist
    else
      @client.store_frame.cart_pur_number_label.should_exist
    end

    # ( WRXT-KVIU-KJDF OEGO-LYSQ-OBMA ):
    # Must Use Tropico 4 for the codes above
    #coupon = "NHKX-RYFA-AWBI"         # for QA2
    coupon = "CUCL-QHEN-KRWM"         # for QA1
    @client.store_frame.coupon_field.value = coupon
    @client.store_frame.apply_coupon_button.click
    @client.store_frame.cart_total_panel.discount_panel.links_list.at(0).inner_text.should == coupon
    @client.store_frame.purchase_as_gift_button.click


    gift_user_name = auto_generate_username
    @client.store_frame.email_or_nickname_field.value = gift_user_name
    @client.store_frame.confirm_email_or_nickname_field.value = gift_user_name
    @client.store_frame.continue_button.click

    # checkout using credit card
    @client.store_frame.checkout_payment_information_label.should_exist
    @client.store_frame.enter_credit_card_info(
      "American Express",
      "371449635398431",
      "Oystein Aarseth",
      "12",
      "2013",
      "gs01"
    )
    @client.store_frame.continue_button.click

    # checkout review
    @client.store_frame.checkout_review_and_submit_label.should_exist
    ImpulseClient.default_timeout = 45
    @client.store_frame.submit_order_button.click
    ImpulseClient.default_timeout = @default_timeout

    order_id = @client.order_number_link.inner_text
    $tracer.trace("order id: #{order_id}")

  end
end