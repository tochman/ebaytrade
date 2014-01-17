#!/usr/bin/env ruby


# Call with: ruby -r "./ebaytrader.rb" -e "get_listing_price"

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
  create_listing
end

def product_xml
  @my_xml = (@mapping).to_xml(:skip_instruct => true, :indent => 2, :skip_types => true)
  #puts @my_xml
end

def mapping(product)
  @mapping = Array.new
  @mapping << {:RequesterCredentials => [:eBayAuthToken => 'token'],
               :Item => [:PrimaryCategory => product[:categories],
                         :Title => product[:name],
                         :Description => product[:description],
                         :Location => 'US',
                         :StartPrice => product[:price],
                         :Quantity => '1',
                         :ListingDuration => 'Days_7',
                         :Country => 'US',
                         :Currency => 'USD',
                         :PaymentMethods => ['PayPal', 'VisaMC', 'PersonalCheck'],
                         :PayPalEmailAddress => 'merchant@merchant.xx']
  }

end

# AddItemRequest
def create_listing
  #XML API Sandbox Gateway URI  https://api.sandbox.ebay.com/ws/api.dll
  #XML API Production Gateway URI https://api.ebay.com/ws/api.dll


  devName = '520176f2-2b66-4e0c-b059-d1847471c159'
  appName = 'AgileVen-8ce3-41da-a24c-25bda594da13'
  certName = '45aa050f-8a58-4cf0-ba85-9cfa6d325b84'
  authToken = 'AgAAAA**AQAAAA**aAAAAA**nYXYUg**nY+sHZ2PrBmdj6wVnY+sEZ2PrA2dj6wFk4GhC5eEowmdj6x9nY+seQ**634CAA**AAMAAA**vpL13VnVQhZj2RjXxNTdFVFXgyDUzyccpR78g8ovnngrjb0OicCCrZOvEubWAWetA7Oez7Bjnu5CWa0WWfctfUQCSQr4nrqZRLfUliYHuQpXggJNVm6GKk+jjfBQkFqHtP2NM3VAQdOnn53w9N/BkVHwhaYkPfNphcSSLeo9Pk+tAXNs7CSI/o6uDb3lhzKFLeCMPpkxwetiUbJz9H4LzJsjCDs6XGBChC7xdfPKcBzllyBdVFSydU8p/m06L087EHmsnIhopHi9S92ToUMhRPMIK201+UUbvhRcTj6tXgreW25ih9fWdhNGatwswjN3YWSzLtv13Ko0YV8Sy/d6WIB0aExCFTcd+osZuSrySN4LEAE5qsZXDyC7XZBeU6gzMOyMYdO6fHWP+nTiQwJm5BNWy54Eu0L6TxCM0Ksc/kUnu/BLX25ZoNZuO6WVAvt/U2s6nawjh2RuEOf0uGqlF7m+z+Goe8/gsr71Ov6IyYgRlN1QFf9gv4CF2c2keyTmpWjK8fLrenxjNHdVXrPBGSicJs2NgOrzYXHEd0feQRYZtnFxsaIXVvPcgKrigKTOmnQBDD2cSGbBlxYei8ZpFFsLO4+nFxfPpQZy5RSHuCtp+fEyRrwQJW0d4hZ7gA2nrhPaSHI9ZLBiJ0F44ceQMznfmpRZhppxZSbfmKOJt/tiIsNFtRIH7NVqvb3v6CzB8yGbYamT1nq2bazUGz77n/kRYMlRZyiW9OfadHl43iinnyoXJB7wSsv0p5I4j/oH'

  url = URI.parse("https://api.sandbox.ebay.com/ws/api.dll")

  req = Net::HTTP::Post.new(url.path)
  req.add_field("X-EBAY-API-COMPATIBILITY-LEVEL", "853")
  req.add_field("X-EBAY-API-DEV-NAME", devName)
  req.add_field("X-EBAY-API-APP-NAME", appName)
  req.add_field("X-EBAY-API-CERT-NAME", certName)
  req.add_field("X-EBAY-API-SITEID", "0")  # '0' is US site
  req.add_field("X-EBAY-API-CALL-NAME", "AddItem")

  req.body = '<?xml version="1.0" encoding="utf-8"?>'+
      '<AddItemRequest xmlns="urn:ebay:apis:eBLBaseComponents">'+
      '<RequesterCredentials>'+
      "<eBayAuthToken>#{authToken}</eBayAuthToken>"+
      '</RequesterCredentials>'+
      @my_xml +
      '</AddItemRequest>?'

  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  http.verify_mode = 0
  res = http.start do |http_runner|
    http_runner.request(req)
  end
  puts res.body

end

