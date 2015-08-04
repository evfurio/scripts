require "#{ENV['QAAUTOMATION_SCRIPTS']}/Impulse/dsl/src/dsl"

describe "Impulse Client Create Account Spec" do
  before(:all) do
    @default_timeout = ImpulseClient.default_timeout
    $tracer.echo = :on
    @client = ImpulseClient.new("C:/gs_client_chromium/GamestopClient/cefhost/Development")
    $snapshots.setup_app(@client)
    @client.open
  end

  before(:each) do
    ImpulseClient.default_timeout = @default_timeout
    @client.nav_bar.gamestop_logo.link.click
    @client.store_frame.featured_games_list.should_exist
  end
  
  after(:all) do
    @client.close
  end

  it "should create a new account" do
    @client.settings_menu.change_log_in_link.click
    @client.login_window.create_account_button.click

    window = @client.create_account_window
    window.account_name_field.value = "Emperor" + date_time_to_compact_string
    window.password_field.value = "4werkonly"
    window.verify_password_field.value = "4werkonly"
    window.next_button.click

    window.wait_for_personal_info_panel
    window.first_name_field.value = name_generator("cvvc")
    window.last_name_field.value = name_generator("cvvcc")
    email = auto_generate_username
    window.email_field.value = email
    window.confirm_email_field.value = email
    window.next_button.click

    window.wait_for_eula_panel
    window.i_agree_button.click

    window.wait_for_launch_panel
    window.launch_button.click

    @client.view_cart_button.click
    @client.store_frame.header_email_address_label.inner_text.should == "( #{email} )"

  end
end