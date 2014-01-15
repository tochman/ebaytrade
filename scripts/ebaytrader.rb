#!/usr/bin/env ruby


# Call with: ruby -r "./ebaytrader.rb" -e "get_listing_price"

require 'rubygems'
require 'json'
require 'net/http'
require 'uri'
require 'builder'

def get_listing_price
  file = open("list_of_products.json")
  json = file.read
  @parsed = JSON.parse(json, {:symbolize_names => true})

  @parsed.each do |product|
    @product = product
  end
  to_ebay = Array.new
  # TODO: This is not needed if we use the entire hash...
  # but can potentially serve as a template for mapping
  to_ebay << @product[:name]
  to_ebay << @product[:price]
  to_ebay << @product[:description]
  to_ebay << @product[:brand][:url]

  product_xml(@product)
end

def product_xml(hash)
  xml = Builder::XmlMarkup.new
  xml.instruct! :xml, :encoding => "ASCII"
  xml.product(hash)
  #puts hash.to_xml(:root => 'product')
  puts xml
end



def create_listing
  uri = URI.parse("http://example.com/search")

  http = Net::HTTP.new(uri.host, uri.port)

  request = Net::HTTP::Post.new(uri.request_uri)
  request.set_form_data({"q" => "My query", "per_page" => "50"})

  response = http.request(request)
end
