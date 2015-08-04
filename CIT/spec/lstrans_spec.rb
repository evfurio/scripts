# d-Con  %QAAUTOMATION_SCRIPTS%\CIT\spec\lstrans_spec.rb  --or  --no_rdb --bt_file "c:/dev/GS.Automation.QAScripts/CIT/bt.lstrans.txt" --tibco_file "c:/dev/GS.Automation.QAScripts/CIT/*lstrans"
# To simplify specifying files on command line, use files ending in lstrans to indicate the Tibco files
# Please note this test actually files because the total cost in the biztalk file and tibco files are off by 2 cents.

require "#{ENV['QAAUTOMATION_SCRIPTS']}/CIT/dsl/src/dsl"

BIZTALK_LS_TRANS = [:order_number, :cust_guid, :insert_date_time, :extract_date_time, :item_id, :number_items, :cost, :currency_code, :item_desc]
TIBCO_LS_TRANS = [:order_number, :affiliate_ind, :insert_date_time, :extract_date_time, :item_id, :number_items, :cost, :currency_code, :cust_email, :payment_type, :zip_code, :item_desc]

describe "CIT LSTRANS File Validator" do
  before(:all) do
    # Read the Biztalk and Tibco files into these arrays, each element will be a hash representing the row read
    @bt_file = load_delimited_file(bt_file_parameter, BIZTALK_LS_TRANS)
    $tracer.trace ("Biztalk LS TRANS file read with #{@bt_file.length} with records")

    @tibco_file = load_delimited_file(tibco_file_parameter, TIBCO_LS_TRANS)
    $tracer.trace ("Tibco LS TRANS file(s) read with #{@tibco_file.length} with records")
  end

  it "should compare the LS TRANS files and write results to report" do
    $tracer.trace("Every record should match by item/sku, number of items, cost, currency and item description")

    # Sort data by item #
    @bt_file.sort_by!{|h| h[:item]}
    @tibco_file.sort_by!{|h| h[:item]}

    fields_of_interest = [:item_id,:number_items,:cost,:currency_code,:item_desc]
    remove_fields_not_needed(@bt_file, fields_of_interest)
    remove_fields_not_needed(@tibco_file, fields_of_interest)

    # Assert record count is same
    $tracer.trace("Assert record count is same")
    @bt_file.length.should eql(@tibco_file.length)

    # Sum totals
    bt_item_count = sum_columns(@bt_file, :number_items)
    bt_total_cost = sum_columns(@bt_file, :cost)
    tibco_item_count = sum_columns(@tibco_file, :number_items)
    tibco_total_cost = sum_columns(@tibco_file, :cost)

    $tracer.trace("Assert item count is same - #{bt_item_count} and #{tibco_item_count}")
    bt_item_count.should eql(tibco_item_count)

    $tracer.trace("Assert total cost is same - #{bt_total_cost} and #{tibco_total_cost}")
    bt_total_cost.should eql(tibco_total_cost)

    # Verify entire array of hashes are identical
    @bt_file.should == @tibco_file

  end
end


private

def load_delimited_file(file_path, ls_trans_cols, delimiter="\t")
  data_read = []
  Dir[file_path].each {|fp|
    CSV.read(fp, {:col_sep => delimiter}).each {|row|
      row_hash = Hash.new
      row.each_with_index {|value, index|
        row_hash[ls_trans_cols[index]] = value.strip unless value.nil?
      }
      data_read << row_hash
    }
  }
  return data_read
end

def remove_fields_not_needed(data_array, fields_of_interest)
  data_array.each {|row|
    row.keys.each {|col_name|
      row.delete(col_name) unless fields_of_interest.include?(col_name)
    }
  }
end

def sum_columns(data_array, col_name)
  data_array.map {|h| h[col_name].to_i}.inject(:+)
end
