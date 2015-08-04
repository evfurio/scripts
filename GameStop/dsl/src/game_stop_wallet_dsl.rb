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

module GameStopWalletDSL

# Enter payment method information by passing the apporpriate parameters for the payment method.
  # === Parameters:
  # _credit_card_type_:: value selected from the credit card type drop down list
  # _credit_card_number_:: value entered into the credit card number text box
  # _exp_month_:: value selected from the card expiration date [month] drop down list
  # _exp_year_:: value selected from the card expiration date [year] drop down list
  def enter_credit_card_info (credit_card_type, credit_card_number, exp_month, exp_year, cvv)
    $tracer.trace("GameStopWalletFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    credit_card_selector.value = credit_card_type
    credit_card_number_field.value = credit_card_number
    credit_card_month_selector.value = exp_month
    credit_card_year_selector.value = exp_year
	  # credit_card_cvv_field.value =  
	  # case credit_card_type.upcase
		  # when "VISA", "MASTERCARD", "DISCOVER" then "123"
		  # when "AMERICAN EXPRESS" then "1234"
	  # else ""
	  # end
	  credit_card_cvv_field.value = cvv
  end
  
	def enter_chkcredit_card_info (credit_card_type, credit_card_number, exp_month, exp_year, cvv)
    $tracer.trace("GameStopWalletFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    if credit_card_type != "PowerUp Rewards Credit Card"
      chkoutcredit_cardtype_selector.value = credit_card_type
		  chkoutcredit_card_number_field.value = credit_card_number
		  chkoutcredit_card_month_selector.value = exp_month
		  chkoutcredit_card_year_selector.value = exp_year
		  chkoutcredit_card_security_field.value = cvv
    else
      # Validate for PURCC only card type and card number are needed
      chkoutcredit_cardtype_selector.value = credit_card_type
      chkoutcredit_card_number_field.value = credit_card_number
      chkoutcredit_card_month_selector.is_visible.should be_false
      chkoutcredit_card_year_selector.is_visible.should be_false
      chkoutcredit_card_security_field.is_visible.should be_false
    end
	end
	
	
	def enter_svs_info (svs_number, pin, svs_balance, order_total)
    $tracer.trace("GameStopWalletFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
		if svs_balance < order_total
		   	$tracer.report("!!!! ATTENTION !!!!!!! There are not enough funds on gift card # #{svs_number}. Please email svsmerchantcertification@storedvalue.com to re-load this card and then re-run this test")
           	svs_balance.should >= order_total		
		end
		gift_card_payment_field.value = svs_number
		gift_card_payment_pin.value = pin
		gift_card_payment_apply.click
    end

end