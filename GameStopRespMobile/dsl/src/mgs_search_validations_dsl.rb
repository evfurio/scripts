module MGSSearchValidationsDSL

  def validate_seo_canonical_link
    $tracer.trace("MGSSearchValidationsDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}")
    mgs_search_canonical_lnk.should_exist
    mgs_search_canonical_lnk.get("href").should == "http://www.gamestop.com/browse"
  end

  def validate_seo_meta_description
    $tracer.trace("MGSSearchValidationsDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}")
    mgs_search_meta_desc.should_exist
    mgs_search_meta_desc.get("content").should include "Browse a wide variety of video games, consoles, electronics and accessories available at GameStop. Shop online or at over 6,000 GameStop stores."
  end


  def validate_loadmore(device)
    $tracer.trace("MGSSearchValidationsDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}")
    mgs_search_product_list.length.should > 0
    product_list_count = mgs_search_product_list.length
    mgs_search_load_more.click
    wait_for_landing_page_load

    mgs_search_product_list.length.should == product_list_count * 2
    $tracer.trace("PRODUCT_LIST LENGTH :::::  #{mgs_search_product_list.length}")
    if device.upcase.strip == "TABLET"
      record_count = mgs_search_record_lbl[0].innerText.strip.split("-")
      $tracer.trace("RECORD COUNT :::::  #{record_count[1].strip}   -   PRODUCT LENGTH :::::  #{mgs_search_product_list.length.to_s}")
      record_count[1].strip.should == mgs_search_product_list.length.to_s
    end
  end

  def validate_search_controls(device)
    $tracer.trace("MGSSearchValidationsDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}")
    if device.upcase.strip == "PHONE"
      mgs_search_filter_btn.is_visible.should == true
      mgs_search_left_section.is_visible.should == false
      mgs_search_record_section.is_visible.should == false
    else
      mgs_search_filter_btn.is_visible.should == false
      mgs_search_left_section.is_visible.should == true
      mgs_search_record_section.is_visible.should == true
    end
    mgs_search_main_section.should_exist
    mgs_search_filter_btn.should_exist
    mgs_search_result_hdr.should_exist
    mgs_search_record_section.should_exist
    mgs_search_record_lbl.should_exist
    mgs_search_prodlist_section.should_exist
    mgs_search_product_list.should_exist
    mgs_search_load_more.should_exist
  end

end