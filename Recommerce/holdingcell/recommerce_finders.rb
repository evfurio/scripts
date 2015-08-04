module ReCommerceFinders

	def recommerce_logo
		$tracer.trace(__method__)
		return ToolTag.new(a.className(create_ats_regex_string("ats-rcmlogolink")), __method__,self)
	end

	def search_header
	    $tracer.trace(__method__)
	    return ToolTag.new(input.className(create_ats_regex_string("ats-rcmdevsearchfield")), __method__, self)
	end

	def search_autocomplete_results
		$tracer.trace(__method__)
		return ToolTag.new(ul.className(create_ats_regex_string("ats-rcmsrchreslist")), __method__, self)
	end

	def search_instruction_label
	    $tracer.trace(__method__)
	    return ToolTag.new(div.className(create_ats_regex_string("ats-rcminstrlbl")), __method__, self)
	end

	def trades_label
	    $tracer.trace(__method__)
	    return ToolTag.new(div.className(create_ats_regex_string("ats-rdmtrdlbl")), __method__, self)
	end

	def trades_label_link
	    $tracer.trace(__method__)
	    return ToolTag.new(a.className(create_ats_regex_string("ats-rdmtradeslnk")), __method__, self)
	end

	def dd_instruction_label
	    $tracer.trace(__method__)
	    return ToolTag.new(h3.className(create_ats_regex_string("ats-rcmddinstrlbl")), __method__, self)
	end

	def dd_serial_label
	    $tracer.trace(__method__)
	    return ToolTag.new(label.className(create_ats_regex_string("ats-rcmddserlbl")), __method__, self)
	end

	def dd_meid_label
	    $tracer.trace(__method__)
	    return ToolTag.new(label.className(create_ats_regex_string("ats-rcmddmeidlbl")), __method__, self)
	end

	def dd_imei_label
	    $tracer.trace(__method__)
	    return ToolTag.new(label.className(create_ats_regex_string("ats-rcmddimeilbl")), __method__, self)
	end

	def dd_serial_field
	    $tracer.trace(__method__)
	    return ToolTag.new(input.className(create_ats_regex_string("ats-rcmddserfld")), __method__, self)
	end	

	def dd_meid_field
	    $tracer.trace(__method__)
	    return ToolTag.new(input.className(create_ats_regex_string("ats-rcmddmeidfld")), __method__, self)
	end
	
	#  new - forgot imei field
	def dd_imei_field
	    $tracer.trace(__method__)
	    return ToolTag.new(input.className(create_ats_regex_string("ats-rcmddimeifld")), __method__, self)
	end	
	
	# end

	def dd_sale_button
	    $tracer.trace(__method__)
	    return ToolTag.new(button.className(create_ats_regex_string("ats-rcmddsalebtn")), __method__, self)
	end

	def dd_trade_button
	    $tracer.trace(__method__)
	    return ToolTag.new(button.className(create_ats_regex_string("ats-rcmddtrdbtn")), __method__, self)
	end

	def dd_green_banner_panel
	    $tracer.trace(__method__)
	    return ToolTag.new(div.className(create_ats_regex_string("ats-rcmddgrnbanpnl")), __method__, self)
	end

	def dd_green_banner_cert_label
	    $tracer.trace(__method__)
	    return ToolTag.new(span.className(create_ats_regex_string("ats-rcmddgrnbancertlbl")), __method__, self)
	end

	def dd_green_banner_serial_label
	    $tracer.trace(__method__)
	    return ToolTag.new(span.className(create_ats_regex_string("ats-rcmddgrnbanserlbl")), __method__, self)
	end

	def dd_green_banner_meid_label
	    $tracer.trace(__method__)
	    return ToolTag.new(span.className(create_ats_regex_string("ats-rcmddgrnbanmeidlbl")), __method__, self)
	end

	def dd_green_banner_sn_label
	    $tracer.trace(__method__)
	    return ToolTag.new(span.className(create_ats_regex_string("ats-rcmddgrnbanimeilbl")), __method__, self)
	end

	def dd_red_banner_panel
	    $tracer.trace(__method__)
	    return ToolTag.new(div.className(create_ats_regex_string("ats-rcmddredbanpnl")), __method__, self)
	end

	def dd_red_banner_panel2
	    $tracer.trace(__method__)
	    return ToolTag.new(div.className(create_ats_regex_string("ats-rcmddbanserlbl")), __method__, self)
	end

	def dd_red_banner_cert_label
	    $tracer.trace(__method__)
	    return ToolTag.new(span.className(create_ats_regex_string("ats-rcmddredbancertlbl")), __method__, self)
	end

	def dd_red_banner_serial_label
	    $tracer.trace(__method__)
	    return ToolTag.new(span.className(create_ats_regex_string("ats-rcmddredbanserlbl")), __method__, self)
	end

	def dd_red_banner_expln_panel
	    $tracer.trace(__method__)
	    return ToolTag.new(div.className(create_ats_regex_string("ats-rcmddredbanexplnpnl")), __method__, self)
	end

	def dd_red_banner_meid
	    $tracer.trace(__method__)
	    return ToolTag.new(span.className(create_ats_regex_string("ats-rcmddredbanmeidlbl")), __method__, self)
	end

	def dd_red_banner_imei_label
	    $tracer.trace(__method__)
	    return ToolTag.new(span.className(create_ats_regex_string("ats-rcmddredbanimeilbl")), __method__, self)
	end
	
	# added error msg finders for invalid serial number, invalid meid and invalid imei
	
	def rcm_dd_serial_error_label
	    $tracer.trace(__method__)
	    return ToolTag.new(span.className(create_ats_regex_string("ats-rcmddserserrorlbl")), __method__, self)
	end

	def rcm_dd_meid_error_label
	    $tracer.trace(__method__)
	    return ToolTag.new(span.className(create_ats_regex_string("ats-rcmddmeiderrorlbl")), __method__, self)
	end

	def rcm_dd_imei_error_label
	    $tracer.trace(__method__)
	    return ToolTag.new(span.className(create_ats_regex_string("ats-rcmddimeierrorlbl")), __method__, self)
	end	
	
	# added finder for GoStores link
	def rcm_trades_label_link
	    $tracer.trace(__method__)
	    return ToolTag.new(div.className(create_ats_regex_string("ats-rcmtradeslnk")), __method__, self)
	end		
	 # end
	 
	# adding finders for the valuation page on recommerce
	def rcm_tab_link
	    $tracer.trace(__method__)
	    return ToolTag.new(td.className(create_ats_regex_string("ats-rcm-tab")), __method__, self)
	end

	def rcm_tab_radio_button
	    $tracer.trace(__method__)
	    return ToolTag.new(input.className(create_ats_regex_string("ats-rcm-tabradio")), __method__, self)
	end
	
	def rcm_val_exclude_label
	    $tracer.trace(__method__)
	    return ToolTag.new(div.className(create_ats_regex_string("ats-rcmvalexclbl")), __method__, self)
	end
	
	def rcm_val_include_label
	    $tracer.trace(__method__)
	    return ToolTag.new(div.className(create_ats_regex_string("ats-rcmvalinclbl")), __method__, self)
	end		

	def rcm_val_excl_chx
	    $tracer.trace(__method__)
	    return ToolTag.new(input.className(create_ats_regex_string("ats-rcmvalexcchx")), __method__, self)
	end		

	def rcm_val_incl_chx
	    $tracer.trace(__method__)
	    return ToolTag.new(input.className(create_ats_regex_string("ats-rcmvalincchx")), __method__, self)
	end	

	def rcm_prod_image
	    $tracer.trace(__method__)
	    return ToolTag.new(img.className(create_ats_regex_string("ats-rcm-prdconddvcimage")), __method__, self)
	end	

	def rcm_val_tab_label
	    $tracer.trace(__method__)
	    return ToolTag.new(label.className(create_ats_regex_string("ats-rcm-tablabel")), __method__, self)
	end	

	def rcm_val_exclude_list
	    $tracer.trace(__method__)
	    return ToolTag.new(div.className(create_ats_regex_string("ats-rcmvalexcllst")), __method__, self)
	end
	
	def rcm_val_include_list
	    $tracer.trace(__method__)
	    return ToolTag.new(div.className(create_ats_regex_string("ats-rcmvalincllst")), __method__, self)
	end	
	
	def rcm_val_condition_panel
	    $tracer.trace(__method__)
	    return GameStopRecomConditionPanelPOS.new(ToolTag.new(tr.className(create_ats_regex_string("ats-rcmvalcondpnl")), __method__, self), self)
	end
	
	def rcm_val_credit_label
	    $tracer.trace(__method__)
	    return ToolTag.new(get_self.p.className(create_ats_regex_string("ats-rcmvalcredlbl")), __method__, self)
	end

	def rcm_val_cash_label
	    $tracer.trace(__method__)
	    return ToolTag.new(get_self.p.className(create_ats_regex_string("ats-rcmvalcashlbl")), __method__, self)
	end	
	# end 
end