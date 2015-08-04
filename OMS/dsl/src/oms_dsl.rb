module OMSDsl
  # === Parameters:
  # _order_csv_file: Full path name to csv file
  # Returns a Hash {'test case 1' => {'dot.object.to.set' => 'value'}}
  # The first line is assumed to be a header line such as: location,tc 1, tc 2, tc 3
  # The first column is always the string representation of the  dot object to set, the remaining columns are values to be used for each test case
  # A blank (empty string) indicates the dot object is not used
  def read_order_file(order_csv_file)
    cr_input = CSV.read(order_csv_file)
    # for each test case in first (header) row
    test_case_criteria = {}
    cr_input[0][1..-1].each_with_index {|tc_name,index|
      element_value_pair = {}
      # for all other rows, get value for each test case
      cr_input[1..-1].each {|row|
        #row[0] contains first column - i.e the Location column
        value = row[index+1]
        element_value_pair[row[0]] = value unless value.nil?
      }
      test_case_criteria[tc_name] = element_value_pair
    }
    return test_case_criteria
  end

  # === Parameters:
  # _request: XmlMessage
  # _parms: Hash of the dot object to set and value
  def update_request(request, parms)
    parms.each {|dot_ref, value|
      set_cmd = "request.#{dot_ref}.value='#{value}'"
      eval(set_cmd)
    }
  end
end