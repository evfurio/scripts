module MGSProductDetailsFunctionsDSL
	
	def view_products_on_pdp(product_urls, start_page, condition, params, db_result)
    $tracer.trace("mgs_responsive_product_details_dsl: #{__method__}, Line: #{__LINE__}")
    $tracer.trace(product_urls)
    i = 0
    product_urls.each_with_index do |url|
      open("#{start_page}/product#{url}")
      $tracer.report("Should #{__method__}: #{start_page}#{url}.")
			# validate products			
      wait_for_landing_page_load
      i += 1
    end
  end
	
	def wait_for_landing_page_load(timeout_ms = 2000)
    $tracer.trace("mgs_responsive_product_details_dsl: #{__method__}, Line : #{__LINE__}")
    sleep timeout_ms/1000 # ruby sleep is in seconds
    return nil
  end
	
end