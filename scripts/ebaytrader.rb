#!/usr/bin/env ruby


# Call with: ruby -r "./ebaytrader.rb" -e "get_listing_price"
# With irb:
# $ irb
# > load './ebaytrader.rb'
# > get_listing_price (or any method you want to call)

require 'rubygems'
require 'nokogiri'
require 'json'
require 'net/http'
require 'uri'
require 'active_support/all'
require 'active_support/xml_mini/nokogiri'


def get_listing_price
  file = open("list_of_products.json")
  @json = file.read
  @parsed = JSON.parse(@json, {:symbolize_names => true})

  @parsed.each do |product|
    @product = product
    mapping(product)
  end

  product_xml
  create_listing
end

def product_xml
  @my_xml = (@mapping).to_xml( :root => 'Item', :skip_instruct => true, :indent => 2, :skip_types => true, :save_with => Nokogiri::XML::Node::SaveOptions::NO_DECLARATION).strip
 # @my_xml = (@mapping).to_xml(:root=>'Item', :skip_instruct => true, :indent => 2, :skip_types => true)
  puts @my_xml
end

def mapping(product)
  @mapping = Array.new
  @mapping << {:Title => product[:name],
              :Description => product[:description],
              :Location => 'US',
              :StartPrice => product[:price],
              :Quantity => '1',
              :ListingDuration => 'Days_7',
              :Country => 'US',
              :Currency => 'USD',
              :PaymentMethods => ['PayPal', 'VisaMC', 'PersonalCheck'],
              :PayPalEmailAddress => 'merchant@merchant.xx'
               }

end

# AddItemRequest
def create_listing
  #XML API Sandbox Gateway URI  https://api.sandbox.ebay.com/ws/api.dll
  #XML API Production Gateway URI https://api.ebay.com/ws/api.dll


  load('myCredentials.rb')


  url = URI.parse("https://api.sandbox.ebay.com/ws/api.dll")

  req = Net::HTTP::Post.new(url.path)
  req.add_field("X-EBAY-API-COMPATIBILITY-LEVEL", "853")
  req.add_field("X-EBAY-API-DEV-NAME", $devId)
  req.add_field("X-EBAY-API-APP-NAME", $appId)
  req.add_field("X-EBAY-API-CERT-NAME", $certId)
  req.add_field("X-EBAY-API-SITEID", "0")  # '0' is US site
  req.add_field("X-EBAY-API-CALL-NAME", "AddItem")

  req.body = '<?xml version="1.0" encoding="utf-8"?>'+
      '<AddItemRequest xmlns="urn:ebay:apis:eBLBaseComponents">'+
      '<RequesterCredentials>'+
      "<eBayAuthToken>#{$authToken}</eBayAuthToken>"+
      '</RequesterCredentials>'+
      @my_xml +
      '</AddItemRequest>'

  #http = Net::HTTP.new(url.host, url.port)
  #http.use_ssl = true
  #http.verify_mode = 0
  #res = http.start do |http_runner|
  #  http_runner.request(req)
  #end
  puts req.body
  #puts res.body

end

