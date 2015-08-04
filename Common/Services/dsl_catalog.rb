module GameStopCatalogServiceDSL

	def perform_get_product_url (version, session_id, sku)
    $tracer.trace("GameStopCatalogServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
		get_products_req = self.get_request_from_template_using_global_defaults(:get_products, CatalogServiceRequestTemplates.const_get("GET_PRODUCTS#{version}"))
		get_products_request_data = get_products_req.find_tag("get_products_request").at(0)
		get_products_request_data.session_id.content = session_id       
		get_products_request_data.skus.string.at(0).content = sku
	
    	get_products_rsp = self.get_products(get_products_req.xml)
		get_products_rsp.code.should == 200
	 
		catalog_get_product_data = get_products_rsp.http_body.find_tag("product").at(0)
		return catalog_get_product_data.url.content
   end
   
   def perform_get_product_by_sku (version, session_id, sku)
     $tracer.trace("GameStopCatalogServiceDSL: #{__method__}, Line: #{__LINE__}")
     $tracer.report("Should #{__method__}.")
		get_products_req = self.get_request_from_template_using_global_defaults(:get_products, CatalogServiceRequestTemplates.const_get("GET_PRODUCTS#{version}"))
		get_products_request_data = get_products_req.find_tag("get_products_request").at(0)
		get_products_request_data.session_id.content = session_id       
		get_products_request_data.skus.string.at(0).content = sku
		$tracer.trace(get_products_request_data.formatted_xml)
		get_products_rsp = self.get_products(get_products_req.xml)
		
		$tracer.trace(get_products_rsp.http_body.get_received_message)
    # $tracer.trace(get_products_rsp.http_body.formatted_xml)
		
		get_products_rsp.code.should == 200
	 
		#catalog_get_product_data = get_products_rsp.http_body.find_tag("product").at(0)
		return get_products_rsp
   end
   
   #Performs a bulk search through the catalog service, gets the first result from the list and returns the product title.
   def perform_bulk_search(version)
     $tracer.trace("GameStopCatalogServiceDSL: #{__method__}, Line: #{__LINE__}")
     $tracer.report("Should #{__method__}.")
		get_products_by_search_req = self.get_request_from_template_using_global_defaults(:get_products_by_search, CatalogServiceRequestTemplates.const_get("GET_PRODUCTS_BY_SEARCH#{version}"))
		
		get_bulk_search_req_data = get_products_by_search_req.find_tag("get_products_by_search_request").at(0)
		
		puts get_bulk_search_req_data
		
		get_bulk_search_req_data.client_channel.content = "GS_US"
		get_bulk_search_req_data.is_in_stock.content = "true"
		get_bulk_search_req_data.is_online_only.content = "false"
		get_bulk_search_req_data.locale.content = "en-US"
		get_bulk_search_req_data.page_index.content = "0"
		get_bulk_search_req_data.page_size.content = "25"
		filters = get_bulk_search_req_data.search_filters.search_filter
		filters.filter_type.content = "Rating"
		filters.filter_values.content = "0"
    get_bulk_search_req_data.search_term.content = nil
    get_bulk_search_req_data.sort_key.content = nil
		get_bulk_search_req_data.sort_order.content = "Descending"
		
		$tracer.trace(get_products_by_search_req.formatted_xml)
		
		get_bulk_search_rsp = self.get_products_by_search(get_products_by_search_req.xml)
		get_bulk_search_rsp.code.should == 200
		
		bulk_results = get_bulk_search_rsp.http_body.find_tag("product").at(0)

		return bulk_results.display_name.content
   end

  def get_products_by_search_keyword(search_term, params, version)
    $tracer.trace(__method__)
    get_products_by_search_req = self.get_request_from_template_using_global_defaults(:get_products_by_search, CatalogServiceRequestTemplates.const_get("GET_PRODUCTS_BY_SEARCH#{version}"))

    search_req_data = get_products_by_search_req.find_tag("get_products_by_search_request").at(0)
    $tracer.trace(search_req_data)

    search_req_data.client_channel.content = "GS_US"
    search_req_data.is_in_stock.content = params['is_in_stock']
    search_req_data.is_online_only.content = params['is_online_only']
    search_req_data.locale.content = "en-US"
    search_req_data.page_index.content = params['page_index']
    search_req_data.page_size.content = params['page_size']
    filters = search_req_data.search_filters.search_filter
    #<!--type: FilterType - enumeration: [Category,Condition,Availability,ESRB,Platform,Price,Rating,Products]-->
    filters.filter_type.content = params['filter_type']
    filters.filter_values.content = params['filter_values']
    search_req_data.search_term.content = search_term
    search_req_data.sort_key.content = nil
    #<!--type: SortOrder - enumeration: [Ascending,Descending]-->
    search_req_data.sort_order.content = params['sort_order']

    get_search_rsp = self.get_products_by_search(get_products_by_search_req.xml)
    get_search_rsp.code.should == 200

    search_result = get_search_rsp.http_body
    return search_result
  end

  def get_product_title_list_by_search(search_term, params, version)
    $tracer.trace(__method__)
    search_result = self.get_products_by_search_keyword(search_term, params, version)
    product = search_result.find_tag("product").at(0).display_name.content
    num_of_products = search_result.find_tag("total_records").content
    return product, num_of_products
  end

  def get_length_for_search_term(search_term, params, version)
    $tracer.trace(__method__)
    search_result = self.get_products_by_search_keyword(search_term, params, version)
    num_of_products = search_result.find_tag("total_records").content
    num_of_products = num_of_products.to_i
    searchable = search_result.find_tag("product")
    $tracer.trace("Is product searchable? #{searchable.is_searchable.at(0).content}")
    displayed_products = ""
    $tracer.trace("Number of products #{num_of_products}")
    if num_of_products > 0
      x = 0
      num_of_products.times do |x|
        is_searchable = searchable.is_searchable.at(x).content
        $tracer.trace("In the loop, is searchable true or false? #{is_searchable}")
        $tracer.trace("Searchable object type class? #{is_searchable.class}")
        if searchable.is_searchable.at(x).content != 'true'
          $tracer.trace("In the IF statement for false on is searchable #{searchable.is_searchable.at(x).content}")
          num_of_products -= 1
          $tracer.trace("Number of displayed products #{num_of_products}")
        else
          num_of_products
          $tracer.trace("Number of displayed products #{num_of_products}")
        end
        x += 1
      end
    end
    return num_of_products
  end

  def verify_operations(catalog_svc)
    $tracer.trace("GameStopCatalogServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    $tracer.trace(catalog_svc)
    catalog_svc.include?(:get_products) == true
    catalog_svc.include?(:get_product_list_by_wild_card) == true
    catalog_svc.include?(:get_product_variant_by_sku) == true
    catalog_svc.include?(:get_inventory_level) == true
    catalog_svc.include?(:get_product_recommendations) == true
    catalog_svc.include?(:get_assembly_info) == true
    catalog_svc.include?(:get_products_by_search) == true
    catalog_svc.include?(:get_navigation_filter_by_type) == true
    catalog_svc.include?(:get_dimension_values_for_category) == true
    return true
  end

	def perform_get_navigation_filter_by_type(version, filter)
	  $tracer.trace("GameStopCatalogServiceDSL: #{__method__}, Line: #{__LINE__}")
	  $tracer.report("Should #{__method__}.")
		svc_req = self.get_request_from_template_using_global_defaults(:get_navigation_filter_by_type, CatalogServiceRequestTemplates.const_get("GET_NAVIGATION_FILTER_BY_TYPE#{version}"))
		
		req_data = svc_req.find_tag("get_navigation_filter_by_type_request").at(0)
		
		req_data.client_channel.content = "GS_US"
		req_data.locale.content = "en-US"
		req_data.filter_type.content = filter	
		$tracer.trace(svc_req.formatted_xml)
		
		svc_rsp = self.get_navigation_filter_by_type(svc_req.xml)
		svc_rsp.code.should == 200
		$tracer.trace(svc_rsp.http_body.formatted_xml)
		
		results = svc_rsp.http_body.find_tag("navigation_filter")
		i=0
		sub_results = []
		while i < results.length
			sub_results << results[i].name.content
			i+=1
		end
		return sub_results
   end
	 
end