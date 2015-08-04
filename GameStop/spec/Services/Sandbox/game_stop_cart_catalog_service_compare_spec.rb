require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"

describe "GameStop SOAP Cart Services Tests" do

    before(:all) do

       $tracer.mode = :on
       $tracer.echo = :on

       WebSpec.default_timeout 30000
       @cart_svc = CartService.new("http://qa.services.gamestop.com/Ecom/Orders/Cart/v1/CartService.svc?wsdl")
       @account_svc = AccountService.new("http://qa.services.gamestop.com/Ecom/Customers/Account/v1/AccountService.svc?wsdl")
       @catalog_svc = CatalogService.new("http://qa.services.gamestop.com/Ecom/Merchandising/Catalog/v1/CatalogService.svc?wsdl")

    end

    it "should authorize an anonymous user through services" do

        session_id = generate_guid

        ###############
        ### ACCOUNT ###
        ###############

        ### AUTHORIZE_ANONYMOUS ###

        # NOTE: The get_request_from_template_using_global_defaults is a dsl.  It will automatically choose the correct
        # corresponding template to be used, and will fill in global defaults into the generated dot object
        authorize_anonymous_req = @account_svc.get_request_from_template_using_global_defaults(:authorize_anonymous)

        authorize_anonymous_data = authorize_anonymous_req.find_tag("authorize_anonymous_request").at(0)
        authorize_anonymous_data.client_anonymous_user_id.content = nil
        authorize_anonymous_data.session_id.content = session_id

        $tracer.trace(authorize_anonymous_req.formatted_xml)

        authorize_anonymous_rsp = @account_svc.authorize_anonymous(authorize_anonymous_req.xml)

        authorize_anonymous_rsp.code.should == 200

        $tracer.trace(authorize_anonymous_rsp.http_body.formatted_xml)

        authorize_result_data = authorize_anonymous_rsp.http_body.find_tag("authorization_result").at(0)
        authorize_result_data.status.content.should == "Authorized"

        # save off owner id for later
        owner_id = authorize_result_data.user_id.content

        ############
        ### CART ###
        ############

        ### ADD_PRODUCTS_TO_CART ###

        # use template to generate a request dot object for the cart service add_products_to_cart operation
        add_products_to_cart_req = @cart_svc.get_request_from_template_using_global_defaults("add_products_to_cart")

        # find "add_products_to_cart_request" in the request dot object and assign data
        add_to_cart_data = add_products_to_cart_req.find_tag("add_products_to_cart_request").at(0)

        # use the saved off owner id received from the authorize request
        add_to_cart_data.owner_id.content = owner_id
        add_to_cart_data.session_id.content = session_id

        product = add_to_cart_data.products.product
        product.quantity.content = "1" # set quantity to 1 now, so we don't have to update each after cloning
        # add sku's to our request product list.  NOTE: we sort for future comparisons
        test_sku_array = [640161, 640263].sort!

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
        ### CATALOG ###
        ###############

        ### GET_PRODUCTS ###

        # use template to generate a request dot object for the cart service add_products_to_cart operation
        get_products_req = @catalog_svc.get_request_from_template_using_global_defaults(:get_products)

        get_products_request_data = get_products_req.find_tag("get_products_request").at(0)
        get_products_request_data.session_id.content = session_id

        (test_sku_array.length - 1).times do
            get_products_request_data.skus.string.at(0).clone_as_sibling
        end

        sku_list = get_products_request_data.skus.string
        sku_list.length.should == test_sku_array.length

        # add the sku's to the sku list
        test_sku_array.each_with_index do |sku, i|
            sku_list.at(i).content = sku.to_s
        end

        $tracer.trace(get_products_req.formatted_xml)

        get_products_rsp = @catalog_svc.get_products(get_products_req.xml)

        get_products_rsp.code.should == 200

        $tracer.trace(get_products_rsp.http_body.formatted_xml)

        catalog_product_list = get_products_rsp.http_body.find_tag("product")

        # sort on sku
        catalog_product_list.sort! do |a,b|
            a.sku.content <=> b.sku.content
        end


        ############
        ### CART ###
        ############

        ### GET_CART ###

        # NOTE: If needed you may specify your own template.  The normal practice is to use the defaults.
        get_cart_req = @cart_svc.get_request_from_template_using_global_defaults(:get_cart, CartServiceRequestTemplates::GET_CART)

        get_req_data = get_cart_req.find_tag("get_cart_request").at(0)
        get_req_data.owner_id.content = owner_id
        get_req_data.session_id.content = session_id

        $tracer.trace(get_cart_req.formatted_xml)

        # call to retrieve cart
        get_cart_rsp = @cart_svc.get_cart(get_cart_req.xml)

        # verify we receive a 200
        get_cart_rsp.code.should == 200

        $tracer.trace(get_cart_rsp.http_body.formatted_xml)

        # get a list of line item id's to be used in removing products from cart
        cart_item_list = get_cart_rsp.http_body.find_tag("item")

        cart_item_list.sort! do |a,b|
            a.sku.content <=> b.sku.content
        end

        # COMPARE - CART to CATALOG

        catalog_product_list.length.should == cart_item_list.length

        catalog_product_list.each_with_index do |catalog_item, i|
            catalog_item.sku.content.should == cart_item_list.at(i).sku.content
            catalog_item.display_name.content.should == cart_item_list.at(i).display_name.content
            format("$%.2f", catalog_item.list_price.content).should == format("$%.2f", cart_item_list.at(i).list_price.content)
        end


    end

end
