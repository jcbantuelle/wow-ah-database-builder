#!/usr/local/bin/ruby

require_relative 'wowhead_item'
require 'csv'
require 'pp'

def invalid_name?(item_name)
  item_name.start_with?('Monster - ', 'Conjured')
end

def invalid_wowhead_item?(item)
  invalid_quality?(item) || item.bind_on_pickup || item.quest_item || item.horde_only || item.conjured
end

def invalid_quality?(item)
  item.quality == 'q0'
end

items = CSV.read('wow-items-db.csv')

CSV.open('ah-items.csv', 'wb') do |csv|
  items.reject { |item|
    invalid_name?(item[1])
  }.each { |item|
    wowhead_item = WowheadItem.new(item)
    csv << wowhead_item.to_a unless invalid_wowhead_item?(wowhead_item)
    pp "Processed Item ##{item[0]}"
  }
end
