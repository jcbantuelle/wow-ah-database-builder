#!/usr/local/bin/ruby

require 'open-uri'
require 'nokogiri'
require 'csv'

def invalid_item?(item)
  return true if invalid_item_name?(item[1])
  # wowhead_page = fetch_wowhead_page(item[0])
  # invalid_item_quality?(wowhead_page)
end

def invalid_item_name?(item_name)
  item_name.start_with?('Monster - ')
end

def invalid_item_quality?(wowhead_page)
  wowhead_page.at_css('.wowhead-tooltip b') == 'q0'
end

def fetch_wowhead_page(item_id)
  Nokogiri::HTML.parse(open("https://classic.wowhead.com/item=#{item_id}"))
end

items = CSV.read('wow-items-db.csv')

CSV.open('ah-items.csv', 'wb') do |csv|
  items.reject{ |item|
    invalid_item?(item)
  }.each{ |item|
    csv << item
  }
end
