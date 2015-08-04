# This file contains the domain specific language (DSL) methods for interacting
# with the GameStop website, Services and related products
# Author:: DTurner
# Copyright:: Copyright (c) 2013 GameStop, Inc.
# Not for external distribution.

#{ENV['QAAUTOMATION_SCRIPTS']}/PowerUpRewards/dsl/src/dsl
#Object.send(:remove_const, :)

module TestHarnessDSL

  def TestHarnessDSL.enroll_existing_member(params, loyaltymembership_svc, email)
    $tracer.trace("TestHarnessDSL : #{__method__}, Line : #{__LINE__}")
    enrolled_email, membership_number, profile_id = loyaltymembership_svc.enroll_existing_user(params, email)
    return enrolled_email, membership_number, profile_id
  end

  def TestHarnessDSL.activate_pur_membership(params, membership_number, open_id, loyaltymembership_svc)
    $tracer.trace("TestHarnessDSL : #{__method__}, Line : #{__LINE__}")
    status = loyaltymembership_svc.activate_pur_membership(params, membership_number, open_id)
    return status
  end

  def get_profile_ship_addr
    $tracer.trace("TestHarnessDSL : #{__method__}, Line : #{__LINE__}")
  end

  def TestHarnessDSL.set_profile_ship_addr(params, customerprofile_svc)
    $tracer.trace("TestHarnessDSL : #{__method__}, Line : #{__LINE__}")
    params[:address_type] = 'Shipping'
    customerprofile_svc.create_address_req(params)
  end

  def remove_profile_ship_addr
    $tracer.trace("TestHarnessDSL : #{__method__}, Line : #{__LINE__}")
  end

  def get_profile_bill_addr
    $tracer.trace("TestHarnessDSL : #{__method__}, Line : #{__LINE__}")
  end

  def TestHarnessDSL.set_profile_bill_addr(params, customerprofile_svc)
    $tracer.trace("TestHarnessDSL : #{__method__}, Line : #{__LINE__}")
    params[:address_type] = 'Billing'
    customerprofile_svc.create_address_req(params)
  end

  def TestHarnessDSL.create_id_with_multipass(params=nil, multipass_svc)
    $tracer.trace("TestHarnessDSL : #{__method__}, Line : #{__LINE__}")
    multipass_svc.create_id_using_multipass
  end

  def TestHarnessDSL.create_profile(open_id, customerprofile_svc)
    $tracer.trace("TestHarnessDSL : #{__method__}, Line : #{__LINE__}")
    customerprofile_svc.create_profile_req(open_id)
  end

  def remove_profile_bill_addr
    $tracer.trace("TestHarnessDSL : #{__method__}, Line : #{__LINE__}")
  end

  def set_bill_ship_addr_same
    $tracer.trace("TestHarnessDSL : #{__method__}, Line : #{__LINE__}")
  end

  def get_mailing_addr
    $tracer.trace("TestHarnessDSL : #{__method__}, Line : #{__LINE__}")
    params[:address_type] = 'Mailing'
    customerprofile_svc.create_address_req(params)
  end

  def TestHarnessDSL.set_mailing_addr(params, customerprofile_svc)
    $tracer.trace("TestHarnessDSL : #{__method__}, Line : #{__LINE__}")
    params[:address_type] = 'Mailing'
    customerprofile_svc.create_address_req(params)
  end

  def remove_mailing_addr
    $tracer.trace("TestHarnessDSL : #{__method__}, Line : #{__LINE__}")
  end

  def get_profile_store_addr
    $tracer.trace("TestHarnessDSL : #{__method__}, Line : #{__LINE__}")
  end

  def set_profile_store_addr
    $tracer.trace("TestHarnessDSL : #{__method__}, Line : #{__LINE__}")
  end

  def remove_profile_store_addr
    $tracer.trace("TestHarnessDSL : #{__method__}, Line : #{__LINE__}")
  end

  def set_home_store_number
    $tracer.trace("TestHarnessDSL : #{__method__}, Line : #{__LINE__}")
  end

  def get_home_store_number
    $tracer.trace("TestHarnessDSL : #{__method__}, Line : #{__LINE__}")
  end

  def get_profile_pur_number
    $tracer.trace("TestHarnessDSL : #{__method__}, Line : #{__LINE__}")
  end

  def set_profile_pur_number
    $tracer.trace("TestHarnessDSL : #{__method__}, Line : #{__LINE__}")
  end

  def get_digital_wallet
    $tracer.trace("TestHarnessDSL : #{__method__}, Line : #{__LINE__}")
  end

  def set_digital_wallet
    $tracer.trace("TestHarnessDSL : #{__method__}, Line : #{__LINE__}")
  end

  def remove_digital_wallet
    $tracer.trace("TestHarnessDSL : #{__method__}, Line : #{__LINE__}")
  end

  def get_profile_cart
    $tracer.trace("TestHarnessDSL : #{__method__}, Line : #{__LINE__}")
  end

  def set_profile_cart
    $tracer.trace("TestHarnessDSL : #{__method__}, Line : #{__LINE__}")
  end

  def remove_profile_cart
    $tracer.trace("TestHarnessDSL : #{__method__}, Line : #{__LINE__}")
  end

  def set_subscribe_to_mailing_list
    $tracer.trace("TestHarnessDSL : #{__method__}, Line : #{__LINE__}")
  end

  def set_unsubscribe_to_mailing_list
    $tracer.trace("TestHarnessDSL : #{__method__}, Line : #{__LINE__}")
  end

end