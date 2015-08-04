qaautomation_dir = ENV['QAAUTOMATION_FILES']
require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"

require 'uri'
require 'net/http'

$tracer.mode=:on
$tracer.echo=:on

describe "Post to Mobile Cart" do

  it "should add products to cart through json post" do
    @payload = {'CartItems' => [{'Sku' => '234231','Quantity' => 1},{'Sku' => '24234','Quantity' => 5},{'Sku' => '324342','Quantity' => 11}]}
    $tracer.trace(@payload.formatted_json)

    config = RestAgentConfig.new
    config.set_user_agent('Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_3_2 like Mac OS X; en-us) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8H7 Safari/6533.18.5')
    config.set_option('content-type', 'application/json')

    client = GameStopCartResource.new('http://m.qa.gamestop.com', config)

  end

end




class Check_Post_Cart

  def more_http
    @user_agent = 'Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_3_2 like Mac OS X; en-us) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8H7 Safari/6533.18.5'
    url = URI.parse('http://m.qa.gamestop.com/Orders/AddToCart')
    @payload = {'CartItems' => [{'Sku' => '234231','Quantity' => 1},{'Sku' => '24234','Quantity' => 5},{'Sku' => '324342','Quantity' => 11}]}

    req, data = Net::HTTP::Post.new(url.path, {'User-Agent' => @user_agent, 'Content-Type' => 'application/json'})
    req.body = @payload
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
    }
    #cookie = res.response['set-cookie']
    puts 'Body = ' + res.body
    puts 'Message = ' + res.message
    puts 'Code = ' + res.code
    #puts "Cookie \n" + cookie
  end

  def the_http
    @user_agent = 'Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_3_2 like Mac OS X; en-us) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8H7 Safari/6533.18.5'
    @payload = {'CartItems' => [{'Sku' => '234231','Quantity' => 1},{'Sku' => '24234','Quantity' => 5},{'Sku' => '324342','Quantity' => 11}]}
    site = Net::HTTP.new('http://m.qa.gamestop.com', 80)
    req = Net::HTTP::Get.new(site, {'User-Agent' => @user_agent})
    res = http.request(req)

    uri = "#{req.url} + /Orders/AddToCart"
    response = Net::HTTP.post_form(uri, @payload)
    puts response.body
    puts response.message
    puts response.code
  end

end

m = Check_Post_Cart.new
m.the_http