require "#{ENV['QAAUTOMATION_SCRIPTS']}/Impulse/dsl/src/dsl"

require "stringio"

describe "Compare Search to XML" do
    class GameStopComponent
      def tag
        return @tag
      end
    end

    class Logger
      def logdev
        return @logdev
      end
    end

    class LogDevice
      def filename
        return @filename
      end
    end

    class Product
      attr_accessor :title, :price, :checked

      def to_s
        return "#{title}, #{price}"
      end
    end



  before(:all) do
    @start_page = "http://www.gamestop.com"
    if os_name == "darwin"
      @browser = GameStopBrowser.new.safari
    else
      @browser = GameStopBrowser.new.ie
    end

    $snapshots.setup(@browser, :all)
    $tracer.mode = :on
    $tracer.echo = :on
    $options.default_timeout = 10000

    @results_dir =  File.dirname($tracer.logdev.filename)
  end

  before(:each) do
    @browser.browser(0).open(@start_page)
  end

  after(:all) do
    $tracer.trace("after :all")
    @browser.close_all
  end

  it "should make sure that the prices on GameStop match the process from the XML feed" do

    xml_filename = @results_dir + "/feed.xml"
    xml_file = File.new(xml_filename, "w")
    error_occured = false

    stdout = StringIO.new
    stderr_str = nil

    IO.popen3("#{ENV["QAAUTOMATION_TOOLS"]}/Windows/misc/bin/wget.exe --no-check-certificate -q -O- https://developer.impulsedriven.com/gsreports/productfeed_us.xml") do |si, so, se|
      stdout.write(so.read)
      stderr_str = se.read
    end

    if !stderr_str.empty?
      raise Exception.new("Could not execute wget command: #{stderr_str}")
    end

    products = Hash.new
    prod = nil
    id = nil

    stdout.rewind
    while (!stdout.eof) do
      l = stdout.readline
      xml_file.write(l)
      l.strip!

      if (l.start_with? "<TryMediaId>")
        l.sub!("<TryMediaId>", "")
        l.sub!("</TryMediaId>", "")
        id = l
      end

      if (l.start_with? "<Title>")
        prod = Product.new
        l.sub!("<Title>", "")
        l.sub!("</Title>", "")
        prod.title = l
      end

      if (l.start_with? "<Price>")
        l.sub!("<Price>", "")
        l.sub!("</Price>", "")
        prod.price = l
        products[id] = prod
        id = nil
        prod = nil
      end

    end

    xml_file.close

    error_filename = @results_dir + "/error_log.txt"
    error_file = File.new(error_filename, "w")

    products.length.should_not == 0
    
    # Search for all products
    @browser.search_button.click

    # Filter on "available for download"
    @browser.a("/Available for Download/").click

    # Filter on "PC"
    @browser.div.id("/LeftColumnPanel/").a("/PC/").click

    # Show 50 items on the page
    @browser.a.id("/btn50Recs/").click

    # Get number of pages
    num_pages_str = @browser.div.className("pagination_controls").strong.at(1).innerText.strip
    num_pages = num_pages_str.to_i

    for i in 1..num_pages do

      prod_list = @browser.product_list
      for j in 0..(prod_list.length - 1) do
        begin
          prod = prod_list.at(j)
          price = prod.price

          href = prod.tag.a.id("/lnkDownload/").href
          id = /productID=([^\&]+)/.match(href)[1]

          if(!products.has_key?(id))
            $tracer.trace("Error: #{id}: #{prod.name_link.inner_text} does not exist in XML feed")
            error_file.puts("Error: #{id}: #{prod.name_link.inner_text} does not exist in XML feed")
            error_file.flush
            error_occured = true
            next
          else
            products[id].checked = true
            if(price != "$#{products[id].price}")
              $tracer.trace("Error: #{id}: #{prod.name_link.inner_text} XML price $#{products[id].price} didn't match website price #{price}")
              error_file.puts("Error: #{id}: #{prod.name_link.inner_text} XML price $#{products[id].price} didn't match website price #{price}")
              error_file.flush
              error_occured = true
              next
            end
          end
        rescue Exception => e
          @browser.snapAll("#{@results_dir}/page#{i}_item#{j}.png")
          html_file = File.new("#{@results_dir}/page#{i}_item#{j}.html", "w")
          html_file.write(@browser.source)
          html_file.close
          $tracer.trace("Error: website issue with product #{prod.name_link.inner_text} #{e.message}\n#{e.backtrace.join("\n")}")
          error_file.puts("Error: website issue with product #{prod.name_link.inner_text} #{e.message}")
          error_occured = true
          error_file.flush
          next
        end
      end

      if i < num_pages
        @browser.a.className("next_page").click
      end

    end

    products.each_pair do |k, v|
      if(!v.checked)
        $tracer.trace("Error: XML product does not exist on website: #{k} #{v}")
        error_file.puts("Error: XML product does not exist on website: #{k} #{v}")
        error_file.flush
        error_occured = true
      end
    end

    raise Exception.new('Mismatch occured. Look for "Error:" in the trace file') if error_occured
  end
  
end
