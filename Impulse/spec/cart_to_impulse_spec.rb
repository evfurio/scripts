require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"

# Note: Exposes the index to the last row in the csv file.
#       This method should become part of QACSV, appropriately.
class QACSV
    def max_row
        return @data.length
    end
end

#	The purpose of this script is to search for Impulse items in GameStop.com and add the products to the Impulse Cart.
#	The SKUs should include products with forced EULA (most EA/Ubisoft) and products with AgeGate.

describe "Cart to Impulse" do
    csv = QACSV.new(csv_filename_parameter)
    @row = csv.range(1, csv.max_row)

    before(:all) do

        WebSpec.default_timeout 30000
        @start_page = "http://www.gamestop.com"
        if os_name == "darwin"
            @browser = GameStopBrowser.new.safari
        else
            @browser = GameStopBrowser.new.ie
        end

        $snapshots.setup(@browser, :all)
        $tracer.mode = :on
        $tracer.echo = :on
    end

    before(:each) do
        @browser.browser(0).open(@start_page)
        @browser.wait_for_landing_page_load
    end

    after(:each) do
        # Remove the product from the cart.
        # Since the remove link causes a pop up to be launched, we need to click
        # OK. The way WebSpec does that is by having you record the action you
        # want to perform before the event happens.
        $tracer.trace("remove_link")
        @browser.record.alert.ok
        tag = ToolTag.new(@browser.a.id("/LinkRemove/"), "remove_link")
        tag.click

        # Ensure cart is empty.
        @browser.source.should include "There are no items in your cart."

    end

    after(:all) do
        $tracer.trace("after :all")
        @browser.close_all
    end

    @row.each do |row|

        product_title = row.find_value_by_name("Impulse Title")
        sku = row.find_value_by_name("SKU")


        it "verify that Impulse products use the Impulse Cart for #{product_title}" do
			# Search for a SKU on gamestop.com & click Add to Cart button
			# SKU comes from the spreadsheet
            @browser.search_field.value = "#{sku}"
            @browser.search_button.click
            @browser.wait_for_landing_page_load
            @browser.buy_first_panel.add_to_cart_button.click

            # If we got the age gate, change the year to an "old enough" value
            # and click "Continue".
            # If not, don't worry about that.
            if @browser.source.include? "Age Verification"
              $tracer.trace("age_year_selector")
              tag = ToolTag.new(@browser.select.id("/Content__Year/"), "age_year_selector")
              tag.option("1968").selected = true

              $tracer.trace("continue_button")
              tag = ToolTag.new(@browser.input.id("/Content__LinkSubmit/"), "continue_button")
              tag.click
            end

            # If we got the EULA, click "Accept".
            # If not, don't worry about that.
            if @browser.source.include? "Please review and accept the following agreement"
              $tracer.trace("agree_button")
              tag = ToolTag.new(@browser.input.id("/Content__Accept/"), "agree_button")
              tag.click
            end

            # Ensure we're on the impulse cart page.
            @browser.url.should start_with "https://impulsestore.gamestop.com/cart"

            # Ensure the product in the cart matches the name in the spreadsheet.
            $tracer.trace("product_name_link")
            tag = ToolTag.new(@browser.a.id("/LinkProductName/"), "product_name_link")
            tag.inner_text.should == "#{product_title}"

            # Rinse and Repeat.

        end
    end

end
