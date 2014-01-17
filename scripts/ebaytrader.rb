#!/usr/bin/env ruby


# Call with: ruby -r "./ebaytrader.rb" -e "get_listing_price"
# With irb:
# $ irb
# > load './ebaytrader.rb'
# > get_listing_price (or any method you want to call)
$:.unshift File.dirname(__FILE__)
$:.unshift File.join(File.dirname(__FILE__),'..', 'lib')
$:.unshift File.join(File.dirname(__FILE__),'..', 'scripts')

require 'rubygems'
require 'eBayAPI'
gem 'soap2r'



def get_listing_price
  file = open("list_of_products.json")
  @json = file.read
  @parsed = JSON.parse(@json, {:symbolize_names => true})

  @parsed.each do |product|
    @product = product
    create_listing(product)
  end

  #product_xml
  #create_listing
end

# AddItemRequest
def create_listing(product)

  load('myCredentials.rb')
  eBay = EBay::API.new($authToken, $devId, $appId, $certId, :sandbox => true)

  resp = eBay.AddItem(:Item => EBay.Item({ :PrimaryCategory => EBay.Category({ :CategoryID => 57882 }),
                                           :Title => product[:name],
                                           :Description => product[:description],
                                           :ConditionID => '1500',
                                           :ConditionDescription => 'Good',
                                           :Location => 'US',
                                           :StartPrice => '1',
                                           :BuyItNowPrice => product[:price],
                                           :Quantity => 1,
                                           :DispatchTimeMax => '3',
                                           :ListingDuration => 'Days_7',
                                           :Country => 'US',
                                           :Currency => 'USD',
                                           :PaymentMethods => 'VisaMC',
                                           #:PayPalEmailAddress => 'magicalbookseller@yahoo.com',
                                           :ShippingDetails => EBay.ShippingDetails(
                                               :ShippingServiceOptions => [
                                                   EBay.ShippingServiceOptions(
                                                       :ShippingService => ShippingServiceCodeType::USPSPriority,
                                                       :ShippingServiceCost => '0.0',
                                                       :ShippingServiceAdditionalCost => '0.0'),
                                                   EBay.ShippingServiceOptions(
                                                       :ShippingService => ShippingServiceCodeType::USPSPriorityFlatRateBox,
                                                       :ShippingServiceCost => '7.0',
                                                       :ShippingServiceAdditionalCost => '0.0')]),
                                          :ReturnPolicy => EBay.ReturnPolicy(
                                              :ReturnsAcceptedOption => 'ReturnsAccepted',
                                              :Description => 'If you are not satisfied, return the item for refund.',
                                              :RefundOption => 'MoneyBack',
                                              :ReturnsWithinOption => 'Days_30'
                                          )}))

  puts "New Item #" + resp.itemID + " added."
  puts "You spent:\n"


end

