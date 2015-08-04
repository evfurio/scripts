# Author:: Ecommerce QA
# Copyright:: Copyright (c) 2014 GameStop, Inc.
# Not for external distribution.

module GameStopProductDetailsValidations

  def validate_add_to_cart_btn
    $tracer.trace("GameStopProductDetailsDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    buy_first_panel.add_to_cart_button.should exist
  end

  def validate_not_available_btn
    $tracer.trace("GameStopProductDetailsDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")

  end

  def validate_wish_list_btn
    $tracer.trace("GameStopProductDetailsDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")

  end

  def validate_jump_to_links
    $tracer.trace("GameStopProductDetailsDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")

  end

  def validate_video_player
    $tracer.trace("GameStopProductDetailsDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")

  end

  def validate_videos_loaded
    $tracer.trace("GameStopProductDetailsDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")

  end

  def validate_screen_shots
    $tracer.trace("GameStopProductDetailsDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")

  end

  def validate_category_label
    $tracer.trace("GameStopProductDetailsDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")

  end

  def validate_url_contains_product_id
    $tracer.trace("GameStopProductDetailsDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")

  end

	def validate_product_conditions(condition, i)
    $tracer.trace("GameStopProductDetailsDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
		conditions = []
		$tracer.trace("Inspect Condition :: " + condition.inspect)
		condition.each { |cond| conditions << cond }
		if conditions[i].to_s.strip.upcase! == "USED"
			product_condition = "PRE-OWNED"
		elsif conditions[i].to_s.strip.upcase! == "DIGITAL"
			product_condition = "DOWNLOAD" #This is a business decision to keep this DOWNLOAD instead of DIGITAL.  Same in the cart.
		else
			product_condition = conditions[i].to_s.strip.upcase!
		end
		product_cond_val = buy_first_panel.condition
		product_cond_val.should include product_condition
		$tracer.trace("Product Condition :: " + product_condition)
		return product_condition
	end

  def validate_product_list_price
    $tracer.trace("GameStopProductDetailsDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")

  end

  def validate_product_price_drop
    $tracer.trace("GameStopProductDetailsDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")

  end

  def validate_platform_text
    $tracer.trace("GameStopProductDetailsDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")

  end

  def validate_platform_image
    $tracer.trace("GameStopProductDetailsDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")

  end

	def validate_product_pur_pro_price
    $tracer.trace("GameStopProductDetailsDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")

		pur_price = self.buy_first_panel.pur_pro_price.innerText
    pur_discount = product_price * 0.10
    pur_price.should == pur_discount
		return pur_price
  end

  def validate_box_art_image
    $tracer.trace("GameStopProductDetailsDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")

  end

  def validate_product_rating
    $tracer.trace("GameStopProductDetailsDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")

  end

  def validate_product_developer
    $tracer.trace("GameStopProductDetailsDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")

  end

  def validate_product_publisher
    $tracer.trace("GameStopProductDetailsDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")

  end

  def validate_esrb_rating
    $tracer.trace("GameStopProductDetailsDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")

  end

  def validate_esrb_rating_text
    $tracer.trace("GameStopProductDetailsDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")

  end

  def validate_product_bonus
    $tracer.trace("GameStopProductDetailsDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")

  end

  def validate_is_bill_ship_match
    $tracer.trace("GameStopProductDetailsDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")

  end

  def validate_is_online_only
    $tracer.trace("GameStopProductDetailsDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")

  end

  def validate_pre_owned_guarantee
    $tracer.trace("GameStopProductDetailsDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")

  end

  def validate_product_is_puas
    $tracer.trace("GameStopProductDetailsDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")

  end

  def validate_is_puas_pre_order
    $tracer.trace("GameStopProductDetailsDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")

  end

  def validate_product_recommendations
    $tracer.trace("GameStopProductDetailsDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")

  end

  def validate_also_bought_recommendations
    $tracer.trace("GameStopProductDetailsDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")

  end

  def validate_cannot_cancel
    $tracer.trace("GameStopProductDetailsDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")

  end

  def validate_additional_handling_fee
    $tracer.trace("GameStopProductDetailsDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")

  end

  def validate_reviews_display
    $tracer.trace("GameStopProductDetailsDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")

  end

  def validate_preview_buzz_display
    $tracer.trace("GameStopProductDetailsDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")

  end

  def validate_social_network_bar
    $tracer.trace("GameStopProductDetailsDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")

  end

  #FIXME: why are we calling directly to HTML elements instead of using finders?
	def get_pur_pro_price
			pur_price = buy_first_panel.pur_pro_price.exists ? money_string_to_decimal(buy_first_panel.pur_pro_price.h3.span.innerText) : 0 
			$tracer.trace("PUR PRO Price: #{pur_price}")
			return pur_price
	end

end