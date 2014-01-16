#!/usr/bin/env ruby


# Call with: ruby -r "./ebaytrader.rb" -e "get_listing_price"

require 'rubygems'
require 'json'
require 'net/http'
require 'uri'
require 'active_support/all'


def get_listing_price
  file = open("list_of_products.json")
  @json = file.read
  @parsed = JSON.parse(@json, {:symbolize_names => true})

  @parsed.each do |product|
    @product = product
    mapping(product)
  end
  product_xml
end

def product_xml
  json = @mapping.to_json
  my_xml = ActiveSupport::JSON.decode(json).to_xml(:root => :product, :type => '')
  puts my_xml
end


def mapping(product)
  @mapping = Array.new
  @mapping << {:name => product[:name],
               :price =>product[:price],
               :description =>product[:description],
               :url =>product[:brand][:url] }
end


def create_listing
  uri = URI.parse("http://example.com/search")

  http = Net::HTTP.new(uri.host, uri.port)

  request = Net::HTTP::Post.new(uri.request_uri)
  request.set_form_data({"q" => "My query", "per_page" => "50"})

  response = http.request(request)
end
