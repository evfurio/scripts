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

module GameStopGiftCardsDSL
	def valid_number?(qty)
		/^[0-9]+$/ === qty
	end
	
	def validate_gc_other_amount(other_amount)
		$tracer.trace("GameStopGiftCardsDSL : #{__method__}")
		error_thrown = valid_number?(other_amount) ? gc_amnt_out_of_range(other_amount.to_i) : gc_amnt_invalid(other_amount)
		return error_thrown
	end

	def validate_gc_quantity(gc_qty)
		$tracer.trace("GameStopGiftCardsDSL : #{__method__}")
		error_thrown = valid_number?(gc_qty) ? gc_qty_out_of_range(purchase_gift_card.at(0).gift_card_quantity.value.to_i) : gc_qty_invalid(purchase_gift_card.at(0).gift_card_quantity.value)
		return error_thrown
	end
	
	def validate_gc_total_amount(gc_total)
		$tracer.trace("GameStopGiftCardsDSL : #{__method__}")
		return gc_total_amount_exceeded(gc_total)	
	end
	
	def gc_amnt_invalid(other_amount)
		$tracer.trace("GameStopGiftCardsDSL : #{__method__}")	
		if other_amount.empty?	
			gift_card_amount_error.should_exist
			gift_card_amount_error.span.innerText.should == 'Please Enter an Amount'
			$tracer.report("Error Message  ::: #{gift_card_amount_error.span.innerText}    Got: #{other_amount}")
		else
			gift_card_amount_error.should_exist
			gift_card_amount_error.span.innerText.should == 'Please Enter Numbers Only'
			$tracer.report("Error Message  ::: #{gift_card_amount_error.span.innerText}    Got: #{other_amount}")
		end
		return true
	end
	
	def gc_amnt_out_of_range(other_amount)
		$tracer.trace("GameStopGiftCardsDSL : #{__method__}")
		case other_amount
		when 0..9	
			gift_card_amount_error.should_exist
			gift_card_amount_error.span.innerText.should == '$10 Minimum Amount'
			$tracer.report("Error Message  ::: #{gift_card_amount_error.span.innerText}    Got: $#{other_amount}")
			error_thrown = true
		when 10..500
			$tracer.trace("OTHER Amount entered is within range.")
			error_thrown = false
		else
			gift_card_amount_error.should_exist
			gift_card_amount_error.span.innerText.should == '$500 Maximum Amount'
			$tracer.report("Error Message  ::: #{gift_card_amount_error.span.innerText}    Got: $#{other_amount}")
			error_thrown = true
		end
		return error_thrown
	end
		
	def gc_qty_invalid(qty)
		$tracer.trace("GameStopGiftCardsDSL : #{__method__}")
		if qty.empty?	
			quantity_error_message.should_exist
			quantity_error_message.span.innerText.should == 'Please Enter a quantity'
			$tracer.report("Error Message  ::: #{quantity_error_message.span.innerText}    Got: #{qty}")
		else
			quantity_error_message.should_exist
			quantity_error_message.span.innerText.should == 'Please Enter Numbers Only'
			$tracer.report("Error Message  ::: #{quantity_error_message.span.innerText}    Got: #{qty}")
		end
		return true
	end			
		
	def gc_qty_out_of_range(qty)
		$tracer.trace("GameStopGiftCardsDSL : #{__method__}")
		case qty
		when 0
			quantity_error_message.should_exist
			quantity_error_message.span.innerText.should == 'Minimum Quantity is 1'  
			$tracer.report("Error Message  ::: #{quantity_error_message.span.innerText}    Got: #{qty}")
			error_thrown = true
		when 1..10
			$tracer.trace("Quantity entered is within range.")
			error_thrown = false
		else
			quantity_error_message.should_exist
			quantity_error_message.span.innerText.should == 'Maximum Quantity is 10'
			$tracer.report("Error Message  :::  #{quantity_error_message.span.innerText}    Got: #{qty}")
			error_thrown = true
		end
		return error_thrown
	end
		
	def gc_total_amount_exceeded(total)
		$tracer.trace("GameStopGiftCardsDSL : #{__method__}")
		if total > 500
			total_amount_error_message.should_exist
			total_amount_error_message.span.innerText.should == 'Total not to Exceed $500' 
			$tracer.report("Error Message  :::  #{total_amount_error_message.span.innerText}    Got: $#{total}")
			error_thrown = true
		else
			$tracer.trace("Total GiftCard amount is within range.")
			error_thrown = false
		end
		return error_thrown
	end
	
end


