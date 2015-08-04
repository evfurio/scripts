#########
##USAGE##
#########

## 
## d-con %QAAUTOMATION_SCRIPTS%\GameStop\spec\Sandbox\tests\string_with_dynamic_variables.rb
##

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"

require 'pairwise'
require 'erb'

describe("PairWise Test") {

  attr_accessor :ratings, :conditions, :availability

  def initialize
    @ratings = ratings
    @conditions = conditions
    @availability = availability
  end

  Pairwise.combinations([@ratings], [@availability], [@conditions]).each do |(prod_vars)|
    it "should do something with the input values" do
      puts "################"
      puts prod_vars.inspect
    end
  end

  def ratings
    return %w(EC E E10 T M RP None)
  end

  def conditions
    return %w(new used digital download)
  end

  def availability
    return %w(A PO BO NFS)
  end
}

########################################################################################################################
class InterceptString

  def create_sql(user_id, product_id)
    template = "Select from shopping_cart where user_id = '<%=user_id%>' and product_id = '<%= product_id%>'"
    result = ERB.new(template).result(binding)
    puts result
  end

end

#str = InterceptString.new
#str.create_sql("123456", "7777777")