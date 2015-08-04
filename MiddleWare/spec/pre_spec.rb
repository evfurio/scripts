#d-Con  %QAAUTOMATION_SCRIPTS%\MiddleWare\Spec\C2S\pre_spec.rb  --or  --prev_file "C:/tmp/mw/prev_file.pre" --curr_file "C:/tmp/mw/curr_file.pre"

require "#{ENV['QAAUTOMATION_SCRIPTS']}/MiddleWare/dsl/src/dsl"

describe "MiddleWare PRE File Validator" do

  before(:all) do
    # Read previous and current files
    @pre_file = PREFile.new(prev_file_parameter, curr_file_parameter)
  end

  it "should check if previous and current files are identical" do
    @pre_file.files_identical?.should be_true
  end

  it "should check if every line of current file is expected length" do
    @pre_file.all_records_expected_length?.should be_true
  end

  it "should check for PRE numbers in previous file but not in current file" do
    prev_not_current = @pre_file.get_keys_in_previous_file_but_not_in_current([:SKU])
    if (prev_not_current.any?)
      $tracer.report("PRE IDs in previous file but not in current file" + prev_not_current.to_s)
    end
    prev_not_current.none?.should be_true
  end

  it "should check for PRE numbers in current file but not in previous file" do
    current_not_prev = @pre_file.get_keys_in_current_file_but_not_in_previous([:SKU])
    if (current_not_prev.any?)
      $tracer.report("PRE IDs in current file but not in previous file" + current_not_prev.to_s)
    end
    current_not_prev.none?.should be_true
  end

  it "should do regex validation of current file" do
    validation_failures = @pre_file.validate_fields
    validation_failures.each do |rec,diff_array|
      $tracer.report(dump_result(rec, diff_array, :validation))
    end
    # If there were no failures, hash should be empty
    validation_failures.empty?.should be_true
  end

  it "should check all fields where values in current file differ from that in previous file" do
    differences = @pre_file.compare_fields([:UPC_number])
    differences.each do |field,diff_array|
      $tracer.report(dump_result(field, diff_array, :compare))
    end
    # If there were no differences, hash should be empty
    differences.empty?.should be_true
  end

  def dump_result(key, diff_array, type)
    trace_output = ''
    trace_output << "\nRECORDS WITH DIFFERENCES IN " + key.to_s + " FIELD ==>\n" if type == :compare
    trace_output << "\nRECORD WHERE REGEX VALIDATION FAILED: " + key.to_s + "==>\n" if type == :validation
    diff_array.each {|ele| trace_output << ele.to_s + "\n"}
    return trace_output
  end

end