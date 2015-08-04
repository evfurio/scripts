# This file contains the domain specific language (DSL) methods for interacting
# with the Game Stop website.
#
# The class named GameStopBrowser is the main class for this DSL.
#
# Author:: Ecommerce QA
# Copyright:: Copyright (c) 2013 GameStop, Inc.
# Not for external distribution.

# == Overview
# This class is the the domain specific language (DSL) class for interacting
# with the Game Stop website. The methods are defined here but are
# accessed via GameStopBrowser.
# = Usage
# See the documentation for GameStopBrowser for examples.
#

module GameStopRecommerceDSL
	
	def validate_rcm_home_page_controls
		trade_in_your_stuff_title.should_exist
		how_works_link.should_exist
		what_trade_link.should_exist
		where_take_link.should_exist
		faqs_link.should_exist
		disclaimer_label.should_exist
	end
	
	def validate_rcm_choose_device_page_controls
		trade_in_your_stuff_title.should_exist
		device_name_label.should_exist
		device_image.should_exist
		product_storage_label.should_exist
		product_connectivity_label.should_exist
	end
	
	def validate_rcm_product_condition_page_controls
		trade_in_your_stuff_title.should_exist
		product_family_label.should_exist
		rcm_product_title_label.should_exist
		model_holder_label.should_exist
		model_number_label.should_exist
		
		product_condition_image.should_exist
		choose_another_device_link.should_exist
		like_new_tab.should_exist		# This is the Working tab
		good_tab.should_exist		# This is the Damaged tab
		poor_tab.should_exist		# This is the Dead tab
		# broken_tab.should_exist		# 4th tab is Not available anymore	
	
		credit_price_label.should_exist
		cash_price_label.should_exist
		print_quote_button.should_exist
		
		store_locator_textbox.should_exist
		store_locator_button.should_exist
	end
	
	def validate_before_after_price(credit_price, cash_price, credit_price_after, cash_price_after)
		#ASSERT: Cash Price / Credit Price should not be equal after clicking the checkbox.
		actual_credit = (credit_price != credit_price_after ? true : false)
		$tracer.trace("Credit Price ::::: #{credit_price}          Credit Price After ::::: #{credit_price_after} ")
		actual_cash = (cash_price != cash_price_after	? true : false)
		$tracer.trace("Cash Price ::::: #{cash_price}          Cash Price After ::::: #{cash_price_after} ")
		actual_credit.should == true
		actual_cash.should == true
	end	
			
	def get_credit_cash_price
		@recycle_credit = (credit_price_label.inner_text.eql?("Recycle") ? true : false )
		credit_price = (@recycle_credit ? 0 : money_string_to_decimal(credit_price_label.inner_text))
		@recycle_cash = (cash_price_label.inner_text.eql?("Recycle") ? true : false )
		cash_price = (@recycle_cash ? 0 : money_string_to_decimal(cash_price_label.inner_text))
		return credit_price, cash_price
	end
	
	def others_applied_to_product
		i = 0
		while i < items_included_checkbox.length
			items_included_checkbox[i].click 
			wait_for_landing_page_load
			i+=1
		end
	end
	
end