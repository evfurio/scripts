#USAGE NOTES#
#advanced - generate credit cards
# This tutorial is to show how to access the CreditCard class and generate credit cards to be used in a script
# Expected results is a mod10 acceptable credit card for each type.  The CreditCard class is plugged into the dsl.rb and can be found in the same directory.
#d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Sandbox\tutorials\advanced\generate_credit_cards.rb --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"

describe "Advanced - CreditCards" do

  before(:all) do
  	#TraceLogger (d-con) C:\dev\QAAutomationCurrent\GameStopDoc\TraceLogger.html
    $tracer.mode=:on
	  $tracer.echo=:on
    $tracer.trace("STEP 1: This is before all")
  end

  before(:each) do
    $tracer.trace("STEP 2: This is before each")
  end

  after(:each) do
    $tracer.trace("STEP 4: This is after each")
  end

  after(:all) do
    $tracer.trace("STEP 5: This is after all")
  end

  it "Invoke the browser and search for a keyword" do
	#USAGE 
    # from the script you need to require 'CreditCard'
	# to generate a card use:
	# ccard = new.CreditCard
	# mastercard = ccard.mastercard
	# visa = ccard.visa
	# amex = ccard.amex
	# discover = ccard.discover
	initialize_payment_params
	@cc_type.each_with_index do |z, y|
			cctype = z

			if cctype == 'AmericanExpress'
				@cc_number = @card_hash["amex"]
        @size = 15
			else
				@cc_number = @card_hash[cctype.downcase]
        @size = 16
      end
      $tracer.report("Valid number? #{CreditCard.valid?(@cc_number.to_s)}")
			$tracer.report("#{z}: #{@cc_number}")
	end
	
  end

  def initialize_payment_params	
		#define what credit card types you'd like to generate a number for
		#Visa, MasterCard, Discover, AmericanExpress are the only supported cards at this time
		@cc_type = ['Visa', 'MasterCard', 'Discover', 'AmericanExpress']
		
		#set the BIN ranges you wish to create cards for.  remember that there is a difference with US/International BIN ranges
		#setting the wrong BIN range can affect your testing.
		#use the following site if you have questions about what BIN ranges to use https://www.bindb.com/bin-list.html
		#be aware that the CreditCard class also defines these ranges, this is an override in case you need to create multiple BIN ranges (i.e. Domestic and International) in a single script.
		@named = {
			:mastercard => { :prefixes => [ '51', '52', '53', '54', '55' ], :size => 16 },
			:visa => { :prefixes => ['4124','4117','411773'], :size => 16 },
			:amex => { :prefixes => ['377481','372888','3764'], :size => 15 },
			:discover => { :prefixes => ['6011', '61'], :size => 16}
			}
		
		#Create an empty array to fill up with the new cards
		card_numbers = []		
		card_types = ['visa', 'mastercard', 'discover', 'amex']
		
		#Use each_with_index to match up the card type and generated numbers in order
		card_types.each_with_index do |i| 
			#we're using method missing here to pass the value 'i' where i is the card type to generate.  
			#this is so we can generate mutliple types of card numbers in this loop
			generated = CreditCard.method_missing("#{i}",@named)
			#we're using the array with the "splat operator (*)" to turn the array into a list for assignment within a hash.  See the Hash converstion below.  In order to do this you must push the type and generated card as a pair into the array.  If you're curious, use puts card_numbers after the loop to see the raw array values.
			card_numbers.push(i,generated)
		end	
		
		#Convert the array pairs to a hash to be called upon.  
		#Usage in script: @cc_number = @card_hash[cctype]
		@card_hash = Hash[*card_numbers]
		
		return @card_hash
	end
  
end
