# To change this template, choose Tools | Templates
# and open the template in the editor.
require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"
require 'dm-core'
require 'dm-timestamps'
require 'dm-migrations'

@path = "#{ENV['QAAUTOMATION_SCRIPTS']}".gsub("\\","\/")
DataMapper::setup(:default, "sqlite3:#{@path}/tutorials/advanced/monitoring_sample.db")

class Test
  include DataMapper::Resource
  property :test_key, String, :key => true
  property :id, String
  property :time, DateTime
  property :ready, Boolean, :default => false
end

#using auto_migrate cleans the database and updates with clean data
#DataMapper.auto_migrate!

#using auto_upgrade will append to the current data store, does not overwrite
DataMapper.auto_upgrade!

logs = Test.new

test_ids = ["Tester1"]

test_ids.each_with_index {|id|
  testers = "#{id}#{Time.now}"
logs.attributes = {
    :test_key => generate_guid,
    :id => testers,
    :time => Time.now,
    :ready => true
}
logs.save
}

if logs.ready
  puts "Ready to run"
else
  puts "Not ready"
end

#class MonitorLog
#   include DataMapper::Resource
#   property :id,         Serial
#   property :sequence,   Text
#   property :start_url,  String
#   property :status,     Integer
#   property :dest_url,   String
#   property :state,      Boolean
#   property :created,    DateTime
#   property :last_modified, DateTime
#   property :end_time,   DateTime
#   property :user,       Text
#   property :machine,    Text
# end
#
# class TestAttributes
#   include DataMapper::Resource
#   property :id,         Serial
#   property :sequence,   Text
#   property :auto_guid,  String
#   property :email,      String
#   property :password,   String
#   property :tc_id,      String
#   property :tc_desc,    String
# end
#
# class ProfileAttributes
#   include DataMapper::Resource
#   property :id,         Serial
#   property :sequence,   Text
#   property :f_name,     String
#   property :m_name,     String
#   property :l_name,     String
# end
#
# class ProductAttributes
#   include DataMapper::Resource
#   property :id,         Serial
#   property :sequence,   Text
#   property :esrb,       String
#   property :condition,  String
# end
#
# class PaymentAttributes
#   include DataMapper::Resource
#   property :id,         Serial
#   property :sequence,   Text
#   property :card_type,  Text
#   property :card_num,   Text
#   property :expired,    Boolean
#   property :month,      Text
#   property :year,       Text
#   property :cvv,        Integer
#   property :svs,        Text
#   property :pin,        Text
#   property :paypal,     Boolean
#   property :pp_user,    String
#   property :pp_pass,    String
# end

#DataMapper.auto_migrate! will wipe out the database

