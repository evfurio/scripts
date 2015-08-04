#d-Con  %QAAUTOMATION_SCRIPTS%\MiddleWare\Spec\C2S\program_spec.rb  --or  --prev_file "C:/tmp/mw/prev_file.program" --curr_file "C:/tmp/mw/curr_file.program"

require "#{ENV['QAAUTOMATION_SCRIPTS']}/MiddleWare/dsl/src/dsl"

describe "MiddleWare Program File Validator" do

  before(:all) do
    # Read previous and current files
    @program_file = ProgramFile.new(prev_file_parameter, curr_file_parameter)
  end

  it "should check if previous and current files are identical" do
    @program_file.files_identical?.should be_true
  end

  it "should check if every line of current file is expected length" do
    @program_file.all_records_expected_length?.should be_true
  end

  it "should check for program in previous file but not in current file" do
    prev_not_current = @program_file.get_keys_in_previous_file_but_not_in_current([:program_id])
    if (prev_not_current.any?)
      $tracer.report("program IDs in previous file but not in current file" + prev_not_current.to_s)
    end
    prev_not_current.none?.should be_true
  end

  it "should check for program in current file but not in previous file" do
    current_not_prev = @program_file.get_keys_in_current_file_but_not_in_previous([:program_id])
    if (current_not_prev.any?)
      $tracer.report("program IDs in current file but not in previous file" + current_not_prev.to_s)
    end
    current_not_prev.none?.should be_true
  end

  it "should do regex validation of current file" do
    validation_failures = @program_file.validate_fields
    validation_failures.each do |rec,diff_array|
      $tracer.report(dump_result(rec, diff_array, :validation))
    end
    # If there were no failures, hash should be empty
    validation_failures.empty?.should be_true
  end

  it "should check all fields where values in current file differ from that in previous file" do
    differences = @program_file.compare_fields([:program_id])
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
