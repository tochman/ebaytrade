#!/usr/bin/env ruby

$:.unshift File.join(File.dirname(__FILE__), "..", "lib")

require 'eBayAPI'

#
# Example of GetSuggestedCategories call
#

# Put your credentials in this file
load('myCredentials.rb')

# Create new eBay caller object.  Omit last argument to use live platform.
eBay = EBay::API.new($authToken, $devId, $appId, $certId, :sandbox => true)

# Call "GetSuggestedCategories"
resp = eBay.GetSuggestedCategories(:Query => "Antiques")

# Report results

if resp.categoryCount.to_i > 0
  resp.suggestedCategoryArray.suggestedCategory.each do |cat|
    puts "  Category ID   : " + cat.category.categoryID.to_s
    puts "  Category Name : " + cat.category.categoryName + " (" + cat.percentItemFound.to_s + "%)"
    puts ""
    #puts " Condition enabled : " +cat.category.conditionEnabled.to_s
  end
else
  puts "No suggested categories found."
end



def cat_features
  resp = eBay.GetCategoryFeatures(:DetailLevel => 'ReturnAll',  :CategoryID  => '1', :FeatureID   => 'ConditionEnabled')
end