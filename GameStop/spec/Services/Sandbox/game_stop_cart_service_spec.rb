require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"

describe "GameStop SOAP Cart Services Tests" do

    before(:all) do

       $tracer.mode = :on
       $tracer.echo = :on

       WebSpec.default_timeout 30000
       @cart_svc = CartService.new("http://qa.services.gamestop.com/Ecom/Orders/Cart/v1/CartService.svc?wsdl")
       @account_svc = AccountService.new("http://qa.services.gamestop.com/Ecom/Customers/Account/v1/AccountService.svc?wsdl")
    end

    before(:each) do
        @session_id = generate_guid
        user_name, user_password = nil

        @owner_id = @account_svc.perform_authorization_and_return_owner_id(@session_id, account_login_parameter, account_password_parameter)
        @cart_svc.perform_empty_cart(@session_id, @owner_id)
    end

    after(:all) do
        @browser.closeAll rescue nil
    end

    it "should add products to cart via services" do

        ############
        ### CART ###
        ############

        ### ADD_PRODUCTS_TO_CART ###

        # NOTE: The normal practice is to use the default template based on the operation, but you may specify your own, though not recommended.
        add_products_to_cart_req = @cart_svc.get_request_from_template_using_global_defaults("add_products_to_cart", CartServiceRequestTemplates::ADD_PRODUCTS_TO_CART)

        # find "add_products_to_cart_request" in the request dot object and assign data
        add_to_cart_data = add_products_to_cart_req.find_tag("add_products_to_cart_request").at(0)

        # use the saved off owner id received from the authorize request
        add_to_cart_data.owner_id.content = @owner_id
        add_to_cart_data.session_id.content = @session_id

        product = add_to_cart_data.products.product
        product.quantity.content = "1" # set quantity to 1 now, so we don't have to update each after cloning

        # add sku's to our request product list.  NOTE: we sort for future comparisons
        test_sku_array = [640161, 952895].sort! #640263].sort! #, 952895].sort!

        # clone the number of sku's we have to add to cart, minus 1, since 1 already exists (from template)
        (test_sku_array.length - 1).times do
            product.clone_as_sibling
        end

        product_list = add_to_cart_data.products.product
        product_list.length.should == test_sku_array.length

        # add the sku's to the product list
        test_sku_array.each_with_index do |sku, i|
            product_list.at(i).sku.content = sku.to_s
            product_list.at(i).quantity.content = (i + 1).to_s # set quantity to 1 now, so we don't have to update each after cloning
        end

        $tracer.trace(add_products_to_cart_req.formatted_xml)

        # call the cart service add products to cart operation
        add_products_to_cart_rsp = @cart_svc.add_products_to_cart(add_products_to_cart_req.xml)

        # verify we receive a 200
        add_products_to_cart_rsp.code.should == 200

        $tracer.trace(add_products_to_cart_rsp.http_body.get_received_message)
        $tracer.trace(add_products_to_cart_rsp.http_body.formatted_xml)

        result_list = add_products_to_cart_rsp.http_body.find_tag("product_result")
        result_list.length.should == test_sku_array.length


        # sort by sku in order we can compare the results -- NOTE: This MAY not be necessary as the results
        # appear to be in the order that they were added... -- either way, this is nice to know if needed.
        sorted_result_list = result_list.sort do |a,b|
            a.sku.content <=> b.sku.content
        end

        # compare each added sku to our results
        test_sku_array.each_with_index do |sku, i|
            sorted_result_list.at(i).add_product_result.content.should == "Success"
            sorted_result_list.at(i).sku.content.should == sku.to_s
            sorted_result_list.at(i).quantity.content.should == (i + 1).to_s
        end


        ###############
        ### BROWSER ###
        ###############

        @browser = GameStopBrowser.new(browser_type_parameter)

        $snapshots.setup(@browser, :all)
        $tracer.mode = :on
        $tracer.echo = :on

        @browser.open("http://qa.gamestop.com")

        # NOTE: had to do this as going to cart first, then login displays a different login page than
        # clicking on it from the main page.
        @browser.my_cart_button.click

        # logout if needed
        if (@browser.timeout(5000).log_out_link.exists)
        #if @browser.log_out_link.exists
            @browser.log_out_link.click
        end

        @browser.log_in_link.click
        @browser.log_in(account_login_parameter, account_password_parameter)

        # ensure we are on cart page
        @browser.my_cart_button.click

        # get cart
        cart_list = @browser.cart_list
        cart_list.length.should == test_sku_array.length

        # verify values.  NOTE: the names should be retrieve from "get_cart" service operation.. but this exercise has
        # been left a test engineer to complete.. see empty cart above for examples.  NOTE: it appears that order on the
        # browser is identical to the order from the service (which makes sense)... but a sort here wouldn't necessarily be
        # a bad idea -- it would have to based on sku's.. which we don't currently have directly from the web page.
        cart_list.at(0).name_link.inner_text.should start_with "Call of Duty: Black Ops"
        cart_list.at(0).quantity_field.value.should start_with "1"
        cart_list.at(1).name_link.inner_text.should start_with "Call of Duty Modern Warfare 3"
        cart_list.at(1).quantity_field.value.should start_with "2"
    end
end









