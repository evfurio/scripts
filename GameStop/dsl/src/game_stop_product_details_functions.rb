# Author:: Ecommerce QA
# Copyright:: Copyright (c) 2014 GameStop, Inc.
# Not for external distribution.

module GameStopProductDetailsFunctions

  def get_product_details

  end

  #FIXME: why are we calling directly to HTML elements instead of using finders?
  def get_pur_pro_price
    pur_price = buy_first_panel.pur_pro_price.exists ? money_string_to_decimal(buy_first_panel.pur_pro_price.h3.span.innerText) : 0
    $tracer.trace("PUR PRO Price: #{pur_price}")
    return pur_price
  end

end