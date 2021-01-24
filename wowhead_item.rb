require 'open-uri'
require 'nokogiri'

class WowheadItem
  attr_reader :id, :name, :page, :quality, :bind_on_pickup, :conjured

  def initialize(item)
    @id = item[0]
    @name = item[1]
    @quality = tooltip_data.at_css('table td b').attribute('class')
    @bind_on_pickup = raw_tooltip.include?('Binds when picked up')
    @conjured = raw_tooltip.include?('Conjured Item')
  end

  def max_stack
    @max_stack ||= max_stack_tooltip.nil? ? 1 : max_stack_tooltip.to_s.delete_prefix('Max Stack: ')
  end

  def sell_price
    @sell_price ||= %w(gold silver copper).reduce('') { |total, coin_type|
      amount = tooltip_data.at_css(".money#{coin_type}")&.content || '00'
      amount = "0" + amount if amount.length == 1
      total << amount
    }.to_i
  end

  def to_a
    [@id, max_stack, sell_price, sell_price * 1.2]
  end

  private

  def wowhead_page
    @wowhead_page ||= open("https://classic.wowhead.com/item=#{@id}").read
  end

  def raw_tooltip
    @raw_tooltip ||= wowhead_page.lines.find { |line|
      line.start_with?(tooltip_prefix)
    }.delete_prefix(tooltip_prefix).delete_suffix('";').gsub(/\\/, '')
  end

  def tooltip_data
    @tooltip_data ||= Nokogiri::HTML.parse(raw_tooltip)
  end

  def tooltip_prefix
    @tooltip_prefix ||= "g_items[#{@id}].tooltip_enus = \""
  end

  def max_stack_tooltip
    @max_stack_tooltip ||= tooltip_data.at_css('.whtt-maxstack')&.content
  end

end
