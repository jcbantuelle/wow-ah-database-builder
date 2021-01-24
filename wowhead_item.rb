require 'open-uri'
require 'nokogiri'

class WowheadItem
  attr_reader :id, :name, :page, :quality

  def initialize(item)
    @id = item[0]
    @name = item[1]
    @page = fetch_wowhead_page
    @quality = tooltip_data.at_css('table td b').attribute('class').to_s.gsub(/\\\"/, '')
  end

  def to_a
    [@id, @name]
  end

  private

  def fetch_wowhead_page
    open("https://classic.wowhead.com/item=#{@id}").read
  end

  def tooltip_data
    @tooltip_data ||= Nokogiri::HTML.parse(
      @page.lines.find { |line|
        line.start_with?(tooltip_prefix)
      }.delete_prefix(tooltip_prefix).delete_suffix('";')
    )
  end

  def tooltip_prefix
    @tooltip_prefix ||= "g_items[#{@id}].tooltip_enus = \""
  end

end
