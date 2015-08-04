# == Overview
# This module is specific to soap services and contains qa d-con script writer dsl's.
# It is mixed into CartService, as a monkey patch, in the dsl.rb file.

module GameStopCartServiceDSL

  # Returns response message from the get_cart operation.
  # Usage:  line_items = perform(get_cart_items(session_id, owner_id)
  #         length = line_items.item.length
  #         item1 = line_items.item.at(0)
  # === Parameters:
  # _session_id_:: session guid
  # _owner_id_:: owner id guid (often retrieved via account authorization - (user_id))
  def perform_get_cart_and_return_message(session_id, owner_id, client_channel, locale, version)
    $tracer.trace("GameStopCartServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    # use template to generate a request dot object for the cart service get_cart operation
    get_cart_req = self.get_request_from_template_using_global_defaults(:get_cart, CartServiceRequestTemplates.const_get("GET_CART#{version}"))

    get_req_data = get_cart_req.find_tag("get_cart_request").at(0)
    get_req_data.owner_id.content = owner_id
    get_req_data.session_id.content = session_id
    get_req_data.client_channel.content = client_channel
    get_req_data.locale.content = locale
    get_cart_req.find_tag("targeting_context").items.name_value_property.remove_self

    $tracer.trace(get_cart_req.formatted_xml)

    # call to retrieve cart
    get_cart_rsp = self.get_cart(get_cart_req.xml)

    $tracer.trace(get_cart_rsp.http_body.get_received_message)
    $tracer.trace(get_cart_rsp.http_body.formatted_xml)

    return get_cart_rsp
  end

  # Retrieves all items from a cart.
  # Usage:  line_items = perform(get_cart_items(session_id, owner_id)
  #         length = line_items.item.length
  #         item1 = line_items.item.at(0)
  # === Parameters:
  # _session_id_:: session guid
  # _owner_id_:: owner id guid (often retrieved via account authorization - (user_id))
  def perform_get_cart_and_return_items(session_id, owner_id, client_channel, locale, version)
    $tracer.trace("GameStopCartServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    get_cart_rsp = perform_get_cart_and_return_message(session_id, owner_id, client_channel, locale, version)

    # verify we receive a 200
    get_cart_rsp.code.should == 200

    # return line items
    return get_cart_rsp.http_body.find_tag("line_items").at(0)
  end

  # Retrieves lineitem guids for all items from a cart.
  # === Parameters:
  # _session_id_:: session guid
  # _owner_id_:: owner id guid (often retrieved via account authorization - (user_id))
  def perform_get_cart_and_return_guids(session_id, owner_id, client_channel, locale, version)
    $tracer.trace("GameStopCartServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    get_cart_rsp_items = perform_get_cart_and_return_items(session_id, owner_id, client_channel, locale, version)
    sku_guids = []
    if get_cart_rsp_items.item.exists == true
      get_cart_rsp_items.item.each do |item|
        sku_guids << item.line_item_id.content
      end
    end
    # return line item ids
    return sku_guids
  end

  def perform_remove_products_from_cart_and_return_message(session_id, owner_id, *sku_guids, client_channel, locale, version)
    $tracer.trace("GameStopCartServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    # use template to generate a request dot object for the cart service remove_products_from_cart operation
    remove_products_from_cart_req = self.get_request_from_template_using_global_defaults(:remove_products_from_cart, CartServiceRequestTemplates.const_get("REMOVE_PRODUCTS_FROM_CART#{version}"))

    remove_product_data = remove_products_from_cart_req.find_tag("remove_products_from_cart_request").at(0)
    remove_product_data.owner_id.content = owner_id
    remove_product_data.session_id.content = session_id
    remove_product_data.client_channel.content = client_channel
    remove_product_data.locale.content = locale
    # get the guid item, and clone as many times as needed
    guid_item = remove_product_data.line_item_i_ds.guid
    (sku_guids.length - 1).times do
      guid_item.clone_as_sibling
    end

    # get this list made from clones of a guid item
    guid_list = remove_products_from_cart_req.find_tag("guid")

    # assign this list with our list from the get_cart operation
    guid_list.each_with_index do |guid, i|
      guid.content = sku_guids[i]
    end

    $tracer.trace(remove_products_from_cart_req.formatted_xml)

    # execute remove products from cart operation
    remove_products_from_cart_rsp = self.remove_products_from_cart(remove_products_from_cart_req.xml)

    $tracer.trace(remove_products_from_cart_rsp.http_body.get_received_message)
    $tracer.trace(remove_products_from_cart_rsp.http_body.formatted_xml)

    return remove_products_from_cart_rsp
  end


  # Removes all items from a cart.  Response message is returned from remove_products_from_cart operation unless the
  # cart is already empty.  If the cart is already empty, nil is returned.
  # === Parameters:
  # _session_id_:: session guid
  # _owner_id_:: owner id guid (often retrieved via account authorization - (user_id))
  def perform_empty_cart_and_return_message(session_id, owner_id, client_channel, locale, version)
    $tracer.trace("GameStopCartServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    remove_products_from_cart_rsp = nil
    line_item_guids = perform_get_cart_and_return_guids(session_id, owner_id, client_channel, locale, version)
    # why call to empty an empty cart if not needed?
    unless line_item_guids.empty?

      remove_products_from_cart_rsp = perform_remove_products_from_cart_and_return_message(session_id, owner_id, *line_item_guids, client_channel, locale, version)
      remove_products_from_cart_rsp.code.should == 200
    end

    return remove_products_from_cart_rsp
  end


  # Removes all items from a cart.  If the cart is already empty, no action is performed.
  # === Parameters:
  # _session_id_:: session guid
  # _owner_id_:: owner id guid (often retrieved via account authorization - (user_id))
  def perform_empty_cart(session_id, owner_id, client_channel, locale, version)
    $tracer.trace("GameStopCartServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    remove_products_from_cart_rsp = perform_empty_cart_and_return_message(session_id, owner_id, client_channel, locale, version)
    unless remove_products_from_cart_rsp.nil? == true
      remove_products_from_cart_rsp.code.should == 200
    end
    return true
  end

  # Add sku/quantity pairs to the cart.  Returns response message for add_products_to_cart.
  # === Parameters:
  # _session_id_:: session guid
  # _owner_id_:: owner id guid (often retrieved via account authorization - (user_id))
  # _*sku_quantity_pairs_:: sku/qty pair variables argument list, ie.: 640161,1,640263,1,640328,2,640330,10,230791,1
  def perform_add_products_to_cart_and_return_message(session_id, owner_id, *sku_quantity_pairs, client_channel, locale, version)
    $tracer.trace("GameStopCartServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    # convert sku/quanity pair variable list into hash 100,1, 101,1, 102,2 ==> {100=>1,101=>1,102=>2}
    sku_hash = Hash[*sku_quantity_pairs]

    add_products_to_cart_req = self.get_request_from_template_using_global_defaults(:add_products_to_cart, CartServiceRequestTemplates.const_get("ADD_PRODUCTS_TO_CART#{version}"))

    # find "add_products_to_cart_request" in the request dot object and assign data
    add_to_cart_data = add_products_to_cart_req.find_tag("add_products_to_cart_request").at(0)

    # use the saved off owner id received from the authorize request
    add_to_cart_data.owner_id.content = owner_id
    add_to_cart_data.session_id.content = session_id
    add_to_cart_data.client_channel.content = client_channel
    add_to_cart_data.locale.content = locale

    product = add_to_cart_data.products.product
    product.quantity.content = "1" # set quantity to 1 now, so we don't have to update each after cloning

    # clone the number of sku's we have to add to cart, minus 1, since 1 already exists (from template)
    (sku_hash.keys.length - 1).times do
      product.clone_as_sibling
    end

    product_list = add_to_cart_data.products.product
    product_list.length.should == sku_hash.keys.length

    # add the sku and qty to the product list
    sku_hash.each_with_index do |(sku, qty), i|
      product_list.at(i).sku.content = sku.to_s
      product_list.at(i).quantity.content = qty.to_s
    end

    $tracer.trace(add_products_to_cart_req.formatted_xml)

    # call the cart service add products to cart operation
    add_products_to_cart_rsp = self.add_products_to_cart(add_products_to_cart_req.xml)

    $tracer.trace(add_products_to_cart_rsp.http_body.get_received_message)
    $tracer.trace(add_products_to_cart_rsp.http_body.formatted_xml)

    return add_products_to_cart_rsp
  end

  # Add sku/quantity pairs to the cart.
  # === Parameters:
  # _session_id_:: session guid
  # _owner_id_:: owner id guid (often retrieved via account authorization - (user_id))
  # _*sku_quantity_pairs_:: sku/qty pair variables argument list, ie.: 640161,1,640263,1,640328,2,640330,10,230791,1
  def perform_add_products_to_cart(session_id, owner_id, *sku_quantity_pairs, client_channel, locale, version)
    $tracer.trace("GameStopCartServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    sku_hash = Hash[*sku_quantity_pairs]
    add_products_to_cart_rsp = perform_add_products_to_cart_and_return_message(session_id, owner_id, *sku_quantity_pairs, client_channel, locale, version)

    add_products_to_cart_rsp.code.should == 200

    result_list = add_products_to_cart_rsp.http_body.find_tag("product_result")
    result_list.length.should == sku_hash.keys.length

    sku_hash.each_with_index do |(sku, qty), i|
      sku = result_list.at(i).sku.content
      result = result_list.at(i).add_product_result.content
      qty = result_list.at(i).quantity.content
      $tracer.report("SKU Used: #{sku}")
      $tracer.report("QTY per SKU: #{qty}")
      $tracer.report("Add To Cart?: #{result}")
      result_list.at(i).add_product_result.content.should == "Success"
      result_list.at(i).sku.content.should == sku.to_s
      result_list.at(i).quantity.content.should == qty.to_s
    end
  end

  def perform_modify_line_item_quantities_and_return_message(session_id, owner_id, *lineitem_qty_list, client_channel, locale, version)
    $tracer.trace("GameStopCartServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    # use template to generate a request dot object for the cart service modify_line_item_quantities operation
    lineitem_hash = Hash[*lineitem_qty_list]
    modify_line_item_quantities_req = self.get_request_from_template_using_global_defaults(:modify_line_item_quantities, CartServiceRequestTemplates.const_get("MODIFY_LINE_ITEM_QUANTITIES#{version}"))

    modify_line_item_data = modify_line_item_quantities_req.find_tag("modify_line_item_quantities_request").at(0)
    modify_line_item_data.owner_id.content = owner_id
    modify_line_item_data.session_id.content = session_id
    modify_line_item_data.client_channel.content = client_channel
    modify_line_item_data.locale.content = locale

    # get the guid item, and clone as many times as needed
    quantity_modification = modify_line_item_data.quantity_modifications.quantity_modification
    #set the updated quantity to 2
    #quantity_modification.quantity.content = "2"

    (lineitem_hash.keys.length - 1).times do
      quantity_modification.clone_as_sibling
    end

    quantity_modification_list = modify_line_item_data.quantity_modifications.quantity_modification
    quantity_modification_list.length.should == lineitem_hash.keys.length

    # add the lineitem and qty to the quantity modification data list
    lineitem_hash.each_with_index do |(line_item_id, qty), i|
      quantity_modification_list.at(i).line_item_id.content = line_item_id.to_s
      quantity_modification_list.at(i).quantity.content = qty.to_s
    end
    puts modify_line_item_quantities_req.formatted_xml
    $tracer.trace(modify_line_item_quantities_req.formatted_xml)

    # execute modify quantity from cart operation
    modify_line_item_quantities_rsp = self.modify_line_item_quantities(modify_line_item_quantities_req.xml)

    $tracer.trace(modify_line_item_quantities_rsp.http_body.get_received_message)
    $tracer.trace(modify_line_item_quantities_rsp.http_body.formatted_xml)
    return modify_line_item_quantities_rsp

  end


  def perform_modify_line_item_fulfillment_channels_and_return_message(session_id, owner_id, *line_item_ids, fulfillment_channel, client_channel, locale, version)
    $tracer.trace("GameStopCartServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    # use template to generate a request dot object for the cart service modify_line_item_fulfillment_channels operation
    modify_line_item_fulfillment_channels_req = self.get_request_from_template_using_global_defaults(:modify_line_item_fulfillment_channels, CartServiceRequestTemplates.const_get("MODIFY_LINE_ITEM_FULFILLMENT_CHANNELS#{version}"))
    modify_line_item_fulfillment_channels_data = modify_line_item_fulfillment_channels_req.find_tag("modify_line_item_fulfillment_channels_request").at(0)
    modify_line_item_fulfillment_channels_data.locale.content = locale
    modify_line_item_fulfillment_channels_data.owner_id.content = owner_id
    modify_line_item_fulfillment_channels_data.session_id.content = session_id

    modify_line_item_fulfillment_channels_data.client_channel.content = client_channel
    line_item_ids.each_with_index do |line_item_id, i|

      modify_line_item_fulfillment_channels_data.fulfillment_channel_modifications.fulfillment_channel_modification.at(0).clone_as_sibling if i > 0
      modify_line_item_fulfillment_channels_data.fulfillment_channel_modifications.fulfillment_channel_modification.at(i).line_item_id.content = line_item_id
      modify_line_item_fulfillment_channels_data.fulfillment_channel_modifications.fulfillment_channel_modification.at(i).channel.content = fulfillment_channel

      $tracer.trace(modify_line_item_fulfillment_channels_req.formatted_xml)

      # execute modify line item fulfillment channel operation

    end
    puts modify_line_item_fulfillment_channels_req.formatted_xml

    modify_line_item_fulfillment_channels_rsp = self.modify_line_item_fulfillment_channels(modify_line_item_fulfillment_channels_req.xml)
    modify_line_item_fulfillment_channels_rsp.code.should == 200
    $tracer.trace(modify_line_item_fulfillment_channels_rsp.http_body.formatted_xml)
    modify_line_item_fulfillment_channels_rsp.http_body.find_tag("fulfillment_channel_modification_result").each do |result|
      result.status.content.should == "Success"
    end


  end

  def perform_add_promotions_to_cart_and_return_message(session_id, owner_id, promotion_code, client_channel, locale, version)
    $tracer.trace("GameStopCartServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    # use template to generate a request dot object for the cart service add_promotions_to_cart operation
    add_promotions_to_cart_req = self.get_request_from_template_using_global_defaults(:add_promotions_to_cart, CartServiceRequestTemplates.const_get("ADD_PROMOTIONS_TO_CART#{version}"))

    add_promotions_to_cart_data = add_promotions_to_cart_req.find_tag("add_promotions_to_cart_request").at(0)
    add_promotions_to_cart_data.owner_id.content = owner_id
    add_promotions_to_cart_data.session_id.content = session_id
    add_promotions_to_cart_data.client_channel.content = client_channel
    add_promotions_to_cart_data.locale.content = locale

    add_promotions_to_cart_data.promotions.promotion.code.content = promotion_code
    puts add_promotions_to_cart_req.formatted_xml

    $tracer.trace(add_promotions_to_cart_req.formatted_xml)

    # execute add promotions to cart operation
    add_promotions_to_cart_rsp = self.add_promotions_to_cart(add_promotions_to_cart_req.xml)
    add_promotions_to_cart_rsp.code.should == 200
    $tracer.trace(add_promotions_to_cart_rsp.http_body.formatted_xml)

    result = add_promotions_to_cart_rsp.http_body.find_tag("result").at(0).content
    return result
  end

  def perform_remove_promotions_from_cart(session_id, owner_id, promotion_code, client_channel, locale, version)
    $tracer.trace("GameStopCartServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    # use template to generate a request dot object for the cart service remove_promotions_from_cart operation
    remove_promotions_from_cart_req = self.get_request_from_template_using_global_defaults(:remove_promotions_from_cart, CartServiceRequestTemplates.const_get("REMOVE_PROMOTIONS_FROM_CART#{version}"))

    remove_promotions_from_cart_data = remove_promotions_from_cart_req.find_tag("remove_promotions_from_cart_request").at(0)
    remove_promotions_from_cart_data.owner_id.content = owner_id
    remove_promotions_from_cart_data.session_id.content = session_id
    remove_promotions_from_cart_data.client_channel.content = client_channel
    remove_promotions_from_cart_data.locale.content = locale

    remove_promotions_from_cart_data.promotions.promotion.code.content = promotion_code
    puts remove_promotions_from_cart_req.formatted_xml

    $tracer.trace(remove_promotions_from_cart_req.formatted_xml)

    # execute remove promotions from cart operation
    remove_promotions_from_cart_rsp = self.remove_promotions_from_cart(remove_promotions_from_cart_req.xml)
    remove_promotions_from_cart_rsp.code.should == 200
    $tracer.trace(remove_promotions_from_cart_rsp.http_body.formatted_xml)
  end

  def perform_apply_loyalty_number_to_cart(session_id, owner_id, loyalty_number, client_channel, locale, version)
    $tracer.trace("GameStopCartServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    # use template to generate a request dot object for the cart service apply_loyalty_number_to_cart operation
    apply_loyalty_number_to_cart_req = self.get_request_from_template_using_global_defaults(:apply_loyalty_number_to_cart, CartServiceRequestTemplates.const_get("APPLY_LOYALTY_NUMBER_TO_CART#{version}"))

    apply_loyalty_number_to_cart_data = apply_loyalty_number_to_cart_req.find_tag("apply_loyalty_number_to_cart_request").at(0)
    apply_loyalty_number_to_cart_data.owner_id.content = owner_id
    apply_loyalty_number_to_cart_data.session_id.content = session_id
    apply_loyalty_number_to_cart_data.client_channel.content = client_channel
    apply_loyalty_number_to_cart_data.locale.content = locale

    apply_loyalty_number_to_cart_data.loyalty_number.content = loyalty_number
    puts apply_loyalty_number_to_cart_req.formatted_xml

    $tracer.trace(apply_loyalty_number_to_cart_req.formatted_xml)

    # execute apply loyalty number to cart operation
    apply_loyalty_number_to_cart_rsp = self.apply_loyalty_number_to_cart(apply_loyalty_number_to_cart_req.xml)
    apply_loyalty_number_to_cart_rsp.code.should == 200
    $tracer.trace(apply_loyalty_number_to_cart_rsp.http_body.formatted_xml)
    return apply_loyalty_number_to_cart_rsp
  end

  def perform_remove_loyalty_number_from_cart(session_id, owner_id, client_channel, locale, version)
    $tracer.trace("GameStopCartServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    # use template to generate a request dot object for the cart service remove_loyalty_number_from_cart operation
    remove_loyalty_number_from_cart_req = self.get_request_from_template_using_global_defaults(:remove_loyalty_number_from_cart, CartServiceRequestTemplates.const_get("REMOVE_LOYALTY_NUMBER_FROM_CART#{version}"))

    remove_loyalty_number_from_cart_data = remove_loyalty_number_from_cart_req.find_tag("remove_loyalty_number_from_cart_request").at(0)
    remove_loyalty_number_from_cart_data.owner_id.content = owner_id
    remove_loyalty_number_from_cart_data.session_id.content = session_id
    remove_loyalty_number_from_cart_data.client_channel.content = client_channel
    remove_loyalty_number_from_cart_data.locale.content = locale

    puts remove_loyalty_number_from_cart_req.formatted_xml

    $tracer.trace(remove_loyalty_number_from_cart_req.formatted_xml)

    # execute remove loyalty number from cart operation
    remove_loyalty_number_from_cart_rsp = self.remove_loyalty_number_from_cart(remove_loyalty_number_from_cart_req.xml)
    remove_loyalty_number_from_cart_rsp.code.should == 200
    $tracer.trace(remove_loyalty_number_from_cart_rsp.http_body.formatted_xml)

  end


  def perform_add_stored_value_products_to_cart(session_id, owner_id, sku, qty, amount, client_channel, locale, version)
    $tracer.trace("GameStopCartServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    # use template to generate a request dot object for the cart service add_stored_value_products_to_cart operation
    add_stored_value_products_to_cart_req = self.get_request_from_template_using_global_defaults(:add_stored_value_products_to_cart, CartServiceRequestTemplates.const_get("ADD_STORED_VALUE_PRODUCTS_TO_CART#{version}"))

    add_stored_value_products_to_cart_data = add_stored_value_products_to_cart_req.find_tag("add_stored_value_products_to_cart_request").at(0)
    add_stored_value_products_to_cart_data.owner_id.content = owner_id
    add_stored_value_products_to_cart_data.session_id.content = session_id
    add_stored_value_products_to_cart_data.client_channel.content = client_channel
    add_stored_value_products_to_cart_data.locale.content = locale

    add_stored_value_products_to_cart_data.stored_value_products.stored_value_product.amount.content = amount
    add_stored_value_products_to_cart_data.stored_value_products.stored_value_product.quantity.content = qty
    add_stored_value_products_to_cart_data.stored_value_products.stored_value_product.sku.content = sku
    puts add_stored_value_products_to_cart_req.formatted_xml

    $tracer.trace(add_stored_value_products_to_cart_req.formatted_xml)

    # execute add stored value products to cart operation
    add_stored_value_products_to_cart_rsp = self.add_stored_value_products_to_cart(add_stored_value_products_to_cart_req.xml)
    add_stored_value_products_to_cart_rsp.code.should == 200
    $tracer.trace(add_stored_value_products_to_cart_rsp.http_body.formatted_xml)
    return add_stored_value_products_to_cart_rsp

  end


  def perform_confirm_age_gate(session_id, owner_id, client_channel, locale, version)
    $tracer.trace("GameStopCartServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    # use template to generate a request dot object for the cart service confirm_age_gate operation
    confirm_age_gate_req = self.get_request_from_template_using_global_defaults(:confirm_age_gate, CartServiceRequestTemplates.const_get("CONFIRM_AGE_GATE#{version}"))

    confirm_age_gate_data = confirm_age_gate_req.find_tag("confirm_age_gate_request").at(0)
    confirm_age_gate_data.owner_id.content = owner_id
    confirm_age_gate_data.session_id.content = session_id
    confirm_age_gate_data.client_channel.content = client_channel
    confirm_age_gate_data.locale.content = locale

    puts confirm_age_gate_req.formatted_xml

    $tracer.trace(confirm_age_gate_req.formatted_xml)

    # execute confirm age gate operation
    confirm_age_gate_rsp = self.confirm_age_gate(confirm_age_gate_req.xml)
    confirm_age_gate_rsp.code.should == 200
    $tracer.trace(confirm_age_gate_rsp.http_body.formatted_xml)
  end

  def perform_migrate_cart(target_session_id, owner_id, target_owner_id, client_channel, locale, version)
    $tracer.trace("GameStopCartServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    # use template to generate a request dot object for the cart service migrate_cart operation

    migrate_cart_req = self.get_request_from_template_using_global_defaults(:migrate_cart, CartServiceRequestTemplates.const_get("MIGRATE_CART#{version}"))

    migrate_cart_data = migrate_cart_req.find_tag("migrate_cart_request").at(0)
    migrate_cart_data.session_id.content = target_session_id
    migrate_cart_data.source_owner_id.content = owner_id
    migrate_cart_data.client_channel.content = client_channel
    migrate_cart_data.locale.content = locale

    migrate_cart_data.target_owner_id.content = target_owner_id

    $tracer.trace(migrate_cart_req.formatted_xml)

    # execute remove products from cart operation
    migrate_cart_rsp = self.migrate_cart(migrate_cart_req.xml)
    migrate_cart_rsp.code.should == 200

    $tracer.trace(migrate_cart_rsp.http_body.formatted_xml)
    return migrate_cart_rsp

  end

	def perform_return_item_quantity_from_cart(session_id, owner_id, client_channel, locale, version)
    $tracer.trace("GameStopCartServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    get_cart_rsp_items = perform_get_cart_and_return_items(session_id, owner_id, client_channel, locale, version)

    quantity = 0

    if get_cart_rsp_items.item.exists == true
      get_cart_rsp_items.item.each do |item|
        quantity += item.quantity.content.to_i
      end
    end
		
		return quantity.to_s
  end
	
  def verify_operations(cart_svc)
    $tracer.trace("GameStopCartServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    $tracer.trace(cart_svc)
    cart_svc.include?(:apply_loyalty_number_to_cart) == true
    cart_svc.include?(:add_products_to_cart) == true
    cart_svc.include?(:add_stored_value_products_to_cart) == true
    cart_svc.include?(:add_promotions_to_cart) == true
    cart_svc.include?(:confirm_age_gate) == true
    cart_svc.include?(:get_cart) == true
    cart_svc.include?(:migrate_cart) == true
    cart_svc.include?(:modify_line_item_fulfillment_channels) == true
    cart_svc.include?(:modify_line_item_quantities) == true
    cart_svc.include?(:remove_loyalty_number_from_cart) == true
    cart_svc.include?(:remove_products_from_cart) == true
    cart_svc.include?(:remove_promotions_from_cart) == true
  end

end

