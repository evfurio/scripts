#####################################################################
### USAGE NOTES
### This script should be run as:
### d-con C:\QAAutomationScripts\DataManager\spec\create_user_spec.rb --no_rdb --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\Profile\profile_dataset.csv -or --range TFS68458 --json "json request"
### Please see file sample_json_req.txt in this directory
###
###Author: spurewal

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"
require "#{ENV['QAAUTOMATION_SCRIPTS']}/Common/DataManagerInterface/data_manager_interface_class"


describe "Create User based on request" do
    before(:all) do
        @request = DataManagerReqInterface.new(json_parameter)
        @global_functions = GlobalFunctions.new()
        @multipass_svc = @global_functions.multipass_svc
        @customerprofile_svc = @global_functions.customerprofile_svc
        @loyaltymembership_svc = @global_functions.loyaltymembership_svc


        @data_results = []
    end

    after(:all) do
	$tracer.report("Task Guid: #{@request.task_guid}")
	@data_results.each do |u|
		$tracer.report("    Created User: #{u['user_name']}, Password: #{u['user_password']}, Status: #{u['status']}")
	end

        DataManagerMail.email_results_message(@request.task_guid, @request.name, @data_results)
    end

    it "should create users with specified attributes" do

        (0...(@request.quantity.to_i)).each do |count|
            # Email address (used as user name) and password are generated
            open_id, user_name, user_password = @multipass_svc.create_id_using_multipass

            # add results to data results array
            @data_results << {"user_name" => user_name, "user_password" => user_password, "status" => "FAIL"}
	    

            # Create an empty profile for this open_id
            profile_id = @customerprofile_svc.create_profile_req(open_id)

            # Always generate a bill address from pool.. this is so even if BILL_ADDR_STATE is IGNORE, we will still utilize it for PUR.
            # NOTE: this will NOT call the service, only generate an address.
            state_code = @request.BILL_ADDR_STATE.values[0].upcase
            is_default = @request.BILL_DEFAULT_ADDR.values[0].upcase == 'YES' ? 'true' : 'false'
            bill_address_params = @customerprofile_svc.generate_address_from_pool(state_code, profile_id, open_id, is_default, 'Billing')

            unless @request.BILL_ADDR_STATE.values[0].upcase == "IGNORE"
                bill_address_response = @customerprofile_svc.create_address_req(bill_address_params)
            end

            unless @request.SHIP_ADDR_STATE.values[0].upcase == "IGNORE"
                state_code = @request.SHIP_ADDR_STATE.values[0].upcase
                is_default = @request.SHIP_DEFAULT_ADDR.values[0].upcase == 'YES' ? 'true' : 'false'

                # generate (get) and address from a pool using state code
                ship_address_params = @customerprofile_svc.generate_address_from_pool(state_code, profile_id, open_id, is_default, 'Shipping')
                ship_address_response = @customerprofile_svc.create_address_req(ship_address_params)
            end

            unless @request.MAIL_ADDR_STATE.values[0].upcase == "IGNORE"
                state_code = @request.MAIL_ADDR_STATE.values[0].upcase
                is_default = @request.MAIL_DEFAULT_ADDR.values[0].upcase == 'YES' ? 'true' : 'false'

                # generate (get) and address from a pool using state code
                mail_address_params = @customerprofile_svc.generate_address_from_pool(state_code, profile_id, open_id, is_default, 'Mailing')
                mail_address_response = @customerprofile_svc.create_address_req(mail_address_params)
            end

            pur_tier = @request.PUR_ENROLL_TIER.values[0]
            if %w(FREE PAID).include? pur_tier.upcase
               phone_number = rand.to_s[2..11]
               store_number = (@request.HAS_STORENUM.values[0].upcase == 'NO') ? "-1" : @request.HAS_STORENUM.values[0]

               # using the generated bill address, convert to a loyalty address (due to params differences) and add non-address info
               params = @customerprofile_svc.convert_to_loyalty_enrollment_address(bill_address_params)
               params = @loyaltymembership_svc.update_loyalty_address_with_non_address_info(params, 'accept', 'tester', phone_number, pur_tier, 'true', store_number)

               # enroll user in pur
               email, membership_number, pur_profile_id = @loyaltymembership_svc.enroll_existing_user(params, user_name)

               # activate user in pur if requested
               @loyaltymembership_svc.activate_pur_membership(params, membership_number, open_id) if @request.PUR_ACTIVATE.values[0].upcase == 'YES'
            end

            # when completely finished, update status to SUCCESS.
            @data_results[count]["status"] = "SUCCESS"
        end
    end
end
