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
      Nokogiri::HTML(URI.open(url, **uri_open_headers)).css(".detail_content").map do |node|
        Hash[detail_content(node)]
      end
    end.flatten
  end

  def detail_content(node)
    node.css('.detail_item').map do |wrapper|
      wrapper.css('.detail_box').map do |box|
        box.css('> div').map do |text|
          val = text.content.gsub(/[[:space:]]+/, " ").strip
          next if val =~ /\d+ ?\/ ?\d+ ?\/ ?\d+/
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
