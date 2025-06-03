require 'open-uri'
require 'nokogiri'
require './app/parser'

module Burnside
  class Parser < ::Parser
    def call
      events.map do |event|
        details = {}
        if date_str = event.css(".agenda-datum").first&.content&.strip.tr(".", "-")
          next if date_str == "Past event"
          date = DateTime.parse(date_str)
          if cutoff > date
            puts "Skipping event: #{date_str} (cutoff: #{cutoff})"
            next
          end

          details[:datum] = date.strftime("%d-%m-%Y")
          # details[:geopend] = "20:00 uur" # date.strftime("%H:%M uur")
          # details[:aanvang] = "20:00 uur" # date.strftime("%H:%M uur")
          # details[:eindtijd] = "23:59 uur" # (date + 4.0/24).strftime("%H:%M uur")
          titles = event.css("a").map { _1.attribute("title")}.compact
          details[:title] = titles.first.content # event.css(".entry-title [itemprop=name]")&.first&.content&.strip || event.css(".entry-title")&.first&.content&.strip
          details[:url] = event.css("a")&.first&.attribute("href")&.content
          # details[:description] = "Updated: #{Time.now.strftime("%d-%m-%Y %H:%M")}"
          details[:locatie] = [
            event.css("[itemprop=location] [itemprop=name]")&.first&.content&.strip,
            event.css("[itemprop=location] [itemprop=streetAddress]")&.first&.content&.strip,
          ].compact.join(", ")
          details[:locatie] = "Burnside Park & Shop, Sint Olafstraat 6" if details[:locatie] == ""
          # locatie: "Concertzaal",
          # eindtijd: "04:00 uur",
          # leeftijd: "16+",
          # type: "",
          # prijs: "€ 7,50",
          details
        else
          throw "Skipping event: no date found in #{event.css("[itemprop=startDate]").first&.attribute("content")&.content}"
        end
      rescue
        pp event.to_html
        pp details
        raise
      end.compact.sort { |a,b| Date.parse(a[:datum]) <=> Date.parse(b[:datum])}
    end

    private

    def events
      @base_urls.map do |url|
        Nokogiri::HTML(URI.open(url, **uri_open_headers)).xpath("//article").map { _1 }
      end.flatten
    end
  end
end
