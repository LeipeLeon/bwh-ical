require 'open-uri'
require 'nokogiri'
require './app/parser'

module Burnside
  class Parser < ::Parser
    def self.call(args)
      new(args).call
    end

    def initialize(args)
      @base_urls = args
    end
    attr_reader :base_urls

    def call
      events.map do |event|
        details = {}
        if date_str = event.css("[itemprop=startDate]").first&.attribute("content")&.content&.strip
          date = DateTime.parse(date_str)
          next if CUTOFF > date
          details[:datum] = date.strftime("%d-%m-%Y")
          # details[:geopend] = "20:00 uur" # date.strftime("%H:%M uur")
          # details[:aanvang] = "20:00 uur" # date.strftime("%H:%M uur")
          # details[:eindtijd] = "23:59 uur" # (date + 4.0/24).strftime("%H:%M uur")
          details[:title] = event.css(".entry-title [itemprop=name]")&.first&.content&.strip
          details[:url] = event.css("[itemprop=url]")&.first.attribute("href").content
          details[:description] = "Updated: #{Time.now.strftime("%d-%m-%Y %H:%M")}"
          details[:locatie] = [
            event.css("[itemprop=location] [itemprop=name]")&.first&.content&.strip,
            event.css("[itemprop=location] [itemprop=streetAddress]")&.first&.content&.strip,
          ].join(", ")
          # locatie: "Concertzaal",
          # eindtijd: "04:00 uur",
          # leeftijd: "16+",
          # type: "",
          # prijs: "€ 7,50",
          details
        end
      rescue
        pp event.content
        pp details
        raise
      end.compact
    end

    private

    def events
      @base_urls.map do |url|
        Nokogiri::HTML(URI.open(url, **uri_open_headers)).xpath("//article").map { _1 }
      end.flatten
    end
  end
end
