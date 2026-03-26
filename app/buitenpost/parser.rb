require "open-uri"
require "nokogiri"
require "json"
require "./app/parser"

module Buitenpost
  class Parser < ::Parser
    BASE_URL = "https://bijbuitenpost.nl"

    def call
      events = event_rows.filter_map do |row|
        text_div = row.at_css(".et_pb_text")
        next unless text_div

        title = text_div.at_css("h2")&.content&.strip
        date_str = text_div.at_css("h3")&.content&.strip
        next unless title && date_str

        date = parse_date(date_str)
        next unless date

        if cutoff > date
          puts "Skipping event: #{date_str} (cutoff: #{cutoff})"
          next
        end

        description = text_div.css("p").map(&:content).map(&:strip).reject(&:empty?).join("\n\n")
        url = row.at_css(".et_pb_button")&.attribute("href")&.content
        url = "#{BASE_URL}#{url}" if url && url.start_with?("/")
        url ||= "#{BASE_URL}/agenda/"

        {
          datum: date.strftime("%d-%m-%Y"),
          title: title,
          url: url,
          description: description,
          locatie: "Landgoed Buitenpost, Rijksstraatweg 7, Twello"
        }
      end

      events.sort_by { |e| Date.parse(e[:datum]) }
    end

    private

    def parse_date(date_str)
      # Handles: "3 april 2026", "5 en 6 april 2026", "22 maart 2026"
      # For multi-day events like "5 en 6 april 2026", use the first date
      cleaned = date_str.gsub(/\s+/, " ").strip
      cleaned = normalize_time(cleaned)

      # Multi-day: "5 en 6 april 2026" or "9 en 10 mei 2026"
      if cleaned =~ /(\d{1,2})\s+en\s+\d{1,2}\s+(\w+)\s+(\d{4})/
        DateTime.parse("#{$1} #{$2} #{$3}")
      else
        DateTime.parse(cleaned)
      end
    rescue Date::Error
      puts "Could not parse date: #{date_str}"
      nil
    end

    def event_rows
      @base_urls.map do |url|
        json = JSON.parse(URI.open(url, **uri_open_headers).read)
        html = json.dig("content", "rendered")
        doc = Nokogiri::HTML(html)
        doc.css(".et_pb_row").select do |row|
          style = row.attribute("style")&.content.to_s
          row.at_css("h2") && row.at_css("h3") && style.include?("#09a0a9")
        end
      end.flatten
    end
  end
end
