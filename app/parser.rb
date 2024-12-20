require 'open-uri'
require 'nokogiri'

class Parser
  def self.call(args)
    new(args).call
  end

  def initialize(args)
    @base_url = args
  end
  attr_reader :base_url

  def call
    urls.map do |url|
      next unless url =~ /\/events\//
      # pp url
      Nokogiri::HTML(URI.open(url, **uri_open_headers)).css(".detail_content").map do |node|
        # pp node.to_html
        # pp
        # detail_content(node)
        Hash[detail_content(node)]
      end
      # break
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
          val = text.content.gsub(/[[:space:]]+/, " ").strip
          next if val =~ /\d+ ?\/ ?\d+ ?\/ ?\d+/
          # puts "     div: #{val}"
          val
        end.compact
      end.transpose
    end.flatten(1).map {|k,v| [k.sub(":","").to_sym, v]}
  end

  private

  def urls
    Nokogiri::HTML(URI.open(@base_url, **uri_open_headers)).xpath("//urlset/url/loc").map { _1.content.strip }
  end

  def uri_open_headers
    {
      "User-Agent" => "Ruby/#{RUBY_VERSION}; Leon Berenschot; https://wendbaar.nl",
      redirect: false
    }
  end
end
