require "#{ENV['QAAUTOMATION_SCRIPTS']}/Impulse/dsl/src/dsl"

describe "Impulse StoreFront Reports" do

    before(:all) do

        WebSpec.default_timeout 30000
        @start_page = "https://impulsestoreadmin.gamestop.com/ssl/admin/sfreports.asp"
		@legacy_start_page = "https://impulsestoreadmin.gamestop.com/ssl_obsolete/admin/sfreports.asp"

        if os_name == "darwin"
            @browser = ImpulseBrowser.new.safari
        else
            @browser = ImpulseBrowser.new.ie
        end

        $snapshots.setup(@browser, :all)
        $tracer.mode = :on
        $tracer.echo = :on
    end

    before(:each) do


    end

    after(:all) do
        $tracer.trace("after :all")
        @browser.close_all
    end

    it "should select pre-order report, enter product ID, and generate report" do
        @browser.browser(0).open(@legacy_start_page)

        @browser.storefront_reports_label.should_exist
        @browser.start_date_field.value = "10/07/2011"
        @browser.end_date_field.value = "10/07/2011"
		
        @browser.select_report_selector.value = "Pre-Order Report"
        @browser.storefront_submit_button.click

        @browser.create_product_report_label.should_exist
        @browser.product_id_field.value = "ESD-IMP-W380"
        @browser.storefront_submit_button.click

        @browser.sales_summary_label.should_exist
    end

    it "should select sales details and generate report" do
        @browser.browser(0).open(@legacy_start_page)

        @browser.storefront_reports_label.should_exist
        @browser.start_date_field.value = "10/07/2011"
        @browser.end_date_field.value = "10/07/2011"
		
        @browser.select_report_selector.value = "Sale Details"
        @browser.storefront_submit_button.click

        @browser.sales_details_label.should_exist
    end

    it "should select sales summary and generate report" do
        @browser.browser(0).open(@legacy_start_page)

        @browser.storefront_reports_label.should_exist
        @browser.start_date_field.value = "10/07/2011"
        @browser.end_date_field.value = "10/07/2011"
		
        @browser.select_report_selector.value = "Sale Summary"
        @browser.storefront_submit_button.click

        @browser.sales_summary_label.should_exist
    end

    it "should select sales by hour, enter product ID, and generate report" do
        @browser.browser(0).open(@legacy_start_page)

        @browser.storefront_reports_label.should_exist
        @browser.start_date_field.value = "10/07/2011"
        @browser.end_date_field.value = "10/07/2011"
		
        @browser.select_report_selector.value = "Sales by Hour"
        @browser.storefront_submit_button.click

        @browser.create_product_report_label.should_exist
        @browser.product_id_field.value = "ESD-IMP-W380"
        @browser.storefront_submit_button.click

        @browser.product_sales_by_hour_summary_label.should_exist
    end

    it "should select transaction service report and generate report" do
        @browser.browser(0).open(@legacy_start_page)

        @browser.storefront_reports_label.should_exist
        @browser.start_date_field.value = "10/07/2011"
        @browser.end_date_field.value = "10/07/2011"
		
        @browser.select_report_selector.value = "Transaction Service Report"
        @browser.storefront_submit_button.click

        @browser.transaction_services_label.should_exist
    end

	# Report does not exist as of 6-25-12
    # it "should select affiliate partners report and generate report" do
        # @browser.browser(0).open(@legacy_start_page)

        # @browser.storefront_reports_label.should_exist
        # @browser.start_date_field.value = "10/07/2011"
        # @browser.end_date_field.value = "10/07/2011"
		
        # @browser.select_report_selector.value = "Affiliate Partners Report"
        # @browser.storefront_submit_button.click

        # @browser.affiliate_sales_summary_label.should_exist
    # end

    it "should select coupon summary and generate report" do
        @browser.browser(0).open(@start_page)

        @browser.storefront_reports_label.should_exist
        @browser.start_date_field.value = "10/07/2011"
        @browser.end_date_field.value = "10/07/2011"
		
        @browser.select_report_selector.value = "Coupon Summary"
        @browser.storefront_submit_button.click

        @browser.coupon_sales_summary_label.should_exist
    end

    it "should select token sales report, enter product ID, and generate report" do
        @browser.browser(0).open(@legacy_start_page)

        @browser.storefront_reports_label.should_exist
        @browser.start_date_field.value = "10/07/2011"
        @browser.end_date_field.value = "10/07/2011"	
		
        @browser.select_report_selector.value = "Token Sales Report"
        @browser.storefront_submit_button.click

        @browser.create_product_report_label.should_exist
        @browser.product_id_field.value = "ESD-IMP-W380"
        @browser.storefront_submit_button.click

        @browser.token_sales_summary_label.should_exist
    end

    # FIX - ODD different results if 10/17/2011 is used instead -- currently passes
    it "should select product sales by country, select product name, and generate report" do
        @browser.browser(0).open(@legacy_start_page)

        @browser.storefront_reports_label.should_exist
        @browser.start_date_field.value = "10/07/2011"
        @browser.end_date_field.value = "10/07/2011"
		
        @browser.select_report_selector.value = "Product Sales by Country"
        @browser.storefront_submit_button.click

        @browser.products_by_country_report_label.should_exist
        @browser.product_selector.value = "Satisfashion"
        @browser.storefront_submit_button.click

        # @browser.products_by_country_report_label.should_exist
        @browser.sales_summary_label.should_exist
    end

    it "should select publisher sales rollup and generate report" do
        @browser.browser(0).open(@legacy_start_page)

        @browser.storefront_reports_label.should_exist
        @browser.start_date_field.value = "10/07/2011"
        @browser.end_date_field.value = "10/07/2011"
		
        @browser.select_report_selector.value = "Publisher Sales Rollup"
        @browser.storefront_submit_button.click

        @browser.publisher_sales_totals_label.should_exist
    end

    it "should select product sales by territory, enter product ID, and generate report" do
        @browser.browser(0).open(@legacy_start_page)

        @browser.storefront_reports_label.should_exist
        @browser.start_date_field.value = "10/07/2011"
        @browser.end_date_field.value = "10/07/2011"
		
        @browser.select_report_selector.value = "Product Sales by Territory"
        @browser.storefront_submit_button.click

        @browser.create_product_report_label.should_exist
        @browser.product_id_field.value = "ESD-IMP-W380"
        @browser.storefront_submit_button.click

        @browser.product_sales_by_territory_label.should_exist
    end

    it "should select orders with coupons and generate report" do
        @browser.browser(0).open(@start_page)

        @browser.storefront_reports_label.should_exist
        @browser.start_date_field.value = "10/07/2011"
        @browser.end_date_field.value = "10/07/2011"
		
        @browser.select_report_selector.value = "Orders With Coupons"
        @browser.storefront_submit_button.click

        @browser.orders_having_coupons_label.should_exist
    end

end
