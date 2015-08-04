#USAGE NOTES
# # d-con %QAAUTOMATION_SCRIPTS%\GameStop\spec\Profile\member_activations_spec.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\Profile\profile_dataset.csv --range TFS68458 --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"
require 'timeout'

$tracer.mode = :on
$tracer.echo = :on

$global_functions = GlobalFunctions.new()

describe "Enroll and Activate PUR" do

  before(:all) do
    #@browser = WebBrowser.new("phantomjs")
    @params = $global_functions.csv
    @loyaltymembership_svc = $global_functions.loyaltymembership_svc
    @account_svc, @account_svc_version = $global_functions.account_svc
    @membership_svc = $global_functions.membership_svc
    @digital_wallet_svc, @digital_wallet_version = $global_functions.digitalwallet_svc
    @purchase_order_svc, @purchase_order_svc_version = $global_functions.purchaseorder_svc
    @payment_svc, @payment_svc_version = $global_functions.payment_svc
    @customerprofile_svc = $global_functions.customerprofile_svc
  end

  before(:each) do
    @session_id = generate_guid
    @user_id = generate_guid
  end

  i = 1
  while i > 0 do
    it "should enroll and activate my users" do
      enrolled_email, membership_number, profile_id, customer_id = @loyaltymembership_svc.enroll_pur_user(@params)
      @account_svc.create_new_user_return_credentials(@user_id, @session_id, enrolled_email, "T3sting1", @account_svc_version)
      open_id = @account_svc.perform_authorization_and_return_user_and_open_id(@session_id, enrolled_email, "T3sting1", @account_svc_version)
      status = @loyaltymembership_svc.activate_pur_membership(@params, membership_number, open_id)
      status.should == "Success"
      member_status = @loyaltymembership_svc.activate_loyalty_membership(@params, membership_number, customer_id, profile_id, open_id, @membership_svc)
      member_status.should == true

      # if @params['add_digital_wallet']
      #   cc = @browser.generate_credit_card("generate")
      #   @payment_svc.perform_save_payment_methods_to_wallet(@client_channel, open_id, cc[:cnum], cc[:expmnth], cc[:expyr], name_on_card = "Accept Tester", cc[:ctype], @payment_svc_version)
      # end

      $tracer.report("Enrolled Email: #{enrolled_email}")
      $tracer.report("Membership Number: #{membership_number}")
      $tracer.report("OpenID: #{open_id}")
      $tracer.report("Card Activation Status: #{status}")
      $tracer.report("Member Activation Status: #{member_status}")

      write_to_csv = false
      if write_to_csv == true
        header = []
        test_info = []
        #dump parameters to a csv for easy import to TFS
        header << "email, password, pur_number, open_id, card_activation_status, member_status, customer_id, profile_id"
        test_info << "#{enrolled_email},#{"T3sting1"},#{membership_number},#{open_id},#{status},#{customer_id},#{profile_id}"
        path = "#{ENV['QAAUTOMATION_SCRIPTS']}/users/"
        Dir.mkdir(path) unless File.exists?(path)

        test_info.each do |i|
          csv_builder(test_info)

          CSV.open("#{path}\\pur_users_and_cards.csv", "a") do |csv|
            csv << @data
          end

        end
      end
    end
  i -= 1
  end

  def csv_builder(tst_info)
    test_info = tst_info.join(",")
    csv_data = "#{test_info}"

    # The parser just converts these into an array of CSV cells
    array_of_csv_cells = CSV.parse csv_data

    # The first CVS row are the headings
    @data = array_of_csv_cells.shift.map { |rd| rd.to_s }

    # Convert the array of CSV cells into an Array of Hashes
    products_in_structures = array_of_csv_cells.map do |cells|
      hsh = {}
      (cells.map { |cell| cell.to_s }).each_with_index do |cell_str, index|
        hsh[index] = cell_str
      end
      hsh
    end

    return @data
  end
end