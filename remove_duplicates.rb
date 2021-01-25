#!/usr/local/bin/ruby

require 'csv'

items = CSV.read('wow-items-db-original.csv')
previous_item_id = nil

CSV.open('wow-items-db-original-without-duplicates.csv', 'ab') do |csv|
  items.each do |item|
    csv << item unless item[0] == previous_item_id
    previous_item_id = item[0]
  end
end
