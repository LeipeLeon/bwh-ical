
require 'open-uri'
require 'nokogiri'
require './app/parser'

module Walhalla
  class Parser < ::Parser
    def call
      events.map do |event|
        details = {}

        if (time_present = event.css(".time-details")&.first.content.strip)
          time = DateTime.parse(normalize_time(time_present))
          details[:datum] = time.strftime("%d-%m-%Y")
          details[:geopend] = time.strftime("%H:%M uur")
          details[:aanvang] = time.strftime("%H:%M uur")
          details[:eindtijd] = (time + 4.0/24).strftime("%H:%M uur")
        end

        details[:locatie] = "Walhalla, Deventer"
        details[:title] = event.css(".summary")&.first.content.strip
        details[:url] = event.css(".url")&.first.attribute("href").content
        # details[:description] = "Updated: #{Time.now.strftime("%d-%m-%Y %H:%M")}"
        # locatie: "Concertzaal",
        # eindtijd: "04:00 uur",
        # leeftijd: "16+",
        # type: "",
        # prijs: "€ 7,50",
        details
      rescue
        pp event.content
        pp details
        raise
      end
    end

    private

    def events
      @base_urls.map do |url|
        Nokogiri::HTML(URI.open(url, **uri_open_headers)).css(".tribe-events-loop .hentry").map { _1 }
      end.flatten
    end
  end
end
