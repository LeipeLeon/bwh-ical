require 'open-uri'
require 'nokogiri'
require './app/parser'

module Bwh
  class Parser < ::Parser
    def call
      urls.map do |url|
        event = Nokogiri::HTML(URI.open(url, **uri_open_headers))
        details = event.css(".detail_content").map { Hash[detail_content(_1)] }
        details[0][:locatie] ||= "Burgerweeshuis, Deventer"
        details[0][:url] = url

        title = event.css("h1.events_title")&.first.content
        details[0][:title] = title

        description = event.at("meta[name='description']")&.[]("content")
        details[0][:description] = "Updated: #{Time.now.strftime("%d-%m-%Y %H:%M")}\n\n" << description

        details
      end.flatten
    end

    def detail_content(node)
      # pp node.to_html
      # puts "detail_content"
      node.css('.detail_item').map do |wrapper|
        # puts "  detail_item"
        wrapper.css('.detail_box').map do |box|
          # puts "    detail_box"
          box.css('> div').map do |text|
            val = if text.children.count == 5 # ["21", "/", "09", "/", "2024"]
              text.children.map { _1.content.tr("/","-") }.join("")
            elsif text.children.count == 2    # ["za 21 sep", "2024"]
              next
            else
              text.content.gsub(/[[:space:]]+/, " ").strip
            end
            # puts "     div: #{val}"
            val
          end.compact
        end.transpose
      end.flatten(1).map {|k,v| [k.sub(":","").to_sym, v]}
    end

    private

    def urls
      @base_urls.map do |url|
        Nokogiri::HTML(URI.open(url, **uri_open_headers)).css(".events_wrapper .events_item .events_content").map {
          "https://www.burgerweeshuis.nl%s" % _1.attribute("href").content
        }
      end.flatten
    end
  end
end
