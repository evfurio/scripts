#USAGE NOTES
# d-Con %QAAUTOMATION_SCRIPTS%\RTFM\advanced\active_record_sample.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Checkout\checkout_dataset.csv --range TFS44309 --or

#require 'active_record'
#require 'activerecord-jdbcsqlite3-adapter' if defined? JRUBY_VERSION
require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"
require 'FileUtils'

class Connection < ActiveRecord::Base
  #stub to create new object instantiation of the active record base class
end

class Orders < Connection
  belongs_to :orders, counter_cache: true
end

describe "Active Record Test" do


  it "should create data dump db" do
    $global_functions = GlobalFunctions.new
    @common_functions = $global_functions.common_function_link
    @common_functions.connect_to_nightly_run_local_data
    order = Orders.create(order_num: "12345227900989", username: "David Test4")
    puts order
  end


#### Shows how to create the schema.  The "create_file" method is now in common_functions
  def create_tables
    #ActiveRecord::Base.clear_active_connections!
    path = "//dl1gsqlt02.testecom.pvt/Users/Public/d_con_data/"
    db_path = "#{path}"
    log_path = "#{path}sqlite3_database"
    self.create_file(log_path, ".log")

    db_conn_base = Connection.new
    db_conn_base.logger = Logger.new(File.open(log_path, 'a'))
    db_conn_base.establish_connection(
        :adapter => 'jdbcsqlite3',
        #:database => "#{ENV['PUBLIC']}/d_con_data/nightly_run_data.db"
        :database => "#{db_path}nightly_run_data.db"
    )

    ActiveRecord::Schema.define do
      unless ActiveRecord::Base.connection.tables.include? 'orders'
        create_table :orders do |table|
          table.column :order_num, :string
          table.column :username, :string
        end
      end

      unless ActiveRecord::Base.connection.tables.include? 'users'
        create_table :users do |table|
          table.column :username, :string
          table.column :password, :string
          table.column :openid, :string
          table.column :loyaltynum, :string
        end
      end
    end
  end

end



