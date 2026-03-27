require "open-uri"
require "nokogiri"
require "json"
require "./app/parser"

module Buitenpost
  class Parser < ::Parser
    BASE_URL = "https://bijbuitenpost.nl"

    def call
      events = event_blocks.filter_map do |block|
        doc = Nokogiri::HTML::DocumentFragment.parse(block)

        title = doc.at_css("h2")&.content&.strip
        date_str = doc.at_css("h3")&.content&.strip
        next unless title && date_str

        date = parse_date(date_str)
        next unless date

        if cutoff > date
          puts "Skipping event: #{date_str} (cutoff: #{cutoff})"
          next
        end

        description = doc.css("p").map(&:content).map(&:strip)
          .reject(&:empty?)
          .reject { |t| t.match?(/\[\/?\w+/) } # strip Divi shortcode text
          .join("\n\n")

        url = extract_button_url(block)
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
      # Handles: "3 april 2026", "5 en 6 april 2026", "5 + 6 april 2026", "22 maart 2026"
      # For multi-day events, use the first date
      cleaned = date_str.gsub(/\s+/, " ").strip
      cleaned = normalize_time(cleaned)

      # Multi-day: "5 en 6 april 2026", "5 + 6 april 2026", "9 en 10 mei 2026"
      if cleaned =~ /(\d{1,2})\s+(?:en|\+)\s+\d{1,2}\s+(\w+)\s+(\d{4})/
        DateTime.parse("#{$1} #{$2} #{$3}")
      else
        DateTime.parse(cleaned)
      end
    rescue Date::Error
      puts "Could not parse date: #{date_str}"
      nil
    end

    def extract_button_url(block)
      # Extract URL from Divi button shortcode: [et_pb_button button_url="..."]
      # Quotes may be encoded as &#8221; &#8243; or regular quotes
      if block =~ /\[et_pb_button\s[^\]]*button_url=["\u201C\u201D\u2033]*([^"\u201C\u201D\u2033\]]+)/
        url = $1.gsub("\\/", "/")
        url
      end
    end

    def event_blocks
      @base_urls.map do |url|
        content = URI.open(url, **uri_open_headers).read
        json = JSON.parse(content)
        html = json.dig("content", "rendered")

        # Decode HTML entities
        decoded = Nokogiri::HTML::DocumentFragment.parse(html).to_html

        # Split content into blocks by [et_pb_row ...] shortcodes
        # Each event block has background_color="#09a0a9"
        blocks = decoded.split(/\[et_pb_row\s/)
        blocks.select { |b| b.include?("#09a0a9") && b.include?("<h2>") }
      end.flatten
    end
  end
end
