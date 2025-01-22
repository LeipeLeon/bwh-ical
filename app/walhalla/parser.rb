
require 'open-uri'
require 'nokogiri'

module Walhalla
  class Parser
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

        if (time_present = event.css(".time-details")&.first.content.strip)
          time = DateTime.parse(normalize_time(time_present))
          details[:datum] = time.strftime("%d-%m-%Y")
          details[:geopend] = time.strftime("%H:%M uur")
          details[:aanvang] = time.strftime("%H:%M uur")
          details[:eindtijd] = (time + 4.0/24).strftime("%H:%M uur")
          details[:locatie] = "Walhalla, Deventer"
        end

        details[:title] = event.css(".summary")&.first.content.strip
        details[:url] = event.css(".url")&.first.attribute("href").content
        details[:description] = "Updated: #{Time.now.strftime("%d-%m-%Y %H:%M")}"
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

    def normalize_time(time_str)
      time_str.sub("januari", "January")
        .sub("februari", "February")
        .sub("maart", "March")
        .sub("april", "April")
        .sub("mei", "May")
        .sub("juni", "June")
        .sub("juli", "July")
        .sub("augustus", "August")
        .sub("september", "September")
        .sub("oktober", "October")
        .sub("november", "November")
        .sub("december", "December")
    end

    def events
      @base_urls.map do |url|
        Nokogiri::HTML(URI.open(url, **uri_open_headers)).css(".tribe-events-loop .hentry").map { _1 }
      end.flatten
    end

    def uri_open_headers
      {
        "User-Agent" => "Ruby/#{RUBY_VERSION}; Leon Berenschot; https://leipeleon.github.io/bwh-ical/",
        redirect: false
      }
    end
  end
end
