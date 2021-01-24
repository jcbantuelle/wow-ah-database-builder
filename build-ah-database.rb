#!/usr/local/bin/ruby

require_relative 'wowhead_item'
require 'csv'

def invalid_name?(item_name)
  item_name.start_with?('Monster - ')
end

def invalid_quality?(wowhead_item)
  wowhead_item.quality == 'q0'
end

items = CSV.read('wow-items-db.csv')

CSV.open('ah-items.csv', 'wb') do |csv|
  items.reject { |item|
    invalid_name?(item[1])
  }.each { |item|
    wowhead_item = WowheadItem.new(item)
    csv << wowhead_item.to_a
  }
end
