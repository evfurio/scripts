module MGSProductDetailsValidationsDSL

	def validate_image_modal
		$tracer.trace("MGSProductDetailsValidationsDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
		mgs_modal_image_section.should_exist
		### TODO: The Image Modal will be revised.
		mgs_modal_image_close.click
		wait_for_landing_page_load
	end

	def validate_video_modal
		$tracer.trace("MGSProductDetailsValidationsDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
		mgs_modal_video_section.should_exist
		### TODO: Try to look for a way on how to validate if video is playing
		sleep 3 
		mgs_modal_video_close.click
		wait_for_landing_page_load
	end

	def validate_details_panel
		$tracer.trace("MGSProductDetailsValidationsDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
		mgs_tab_details_text.should_exist
		mgs_tab_details_more.click if mgs_tab_details_more.call("style.display").include?("inline") == true
		wait_for_landing_page_load
		mgs_tab_details_less.click if mgs_tab_details_less.call("style.display").include?("inline") == true
		wait_for_landing_page_load
	end

end