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
    urls.each do |url|
      next unless url =~ /\/events\//
      pp url
      Nokogiri::HTML(URI.open(url)).css(".detail_content").each do |node|
        pp node.to_html
        # pp
        detail_content(node)
        # pp Hash[detail_content(node)]
      end
      # break
    end
  end

  def detail_content(node)
    puts "detail_content"
    node.css('.detail_item').map do |wrapper|
      puts "  detail_item"
      wrapper.css('.detail_box').map do |box|
        puts "    detail_box"
        box.css('> div').map do |text|
          val = text.content.gsub(/[[:space:]]+/, " ").strip
          next if val =~ /\d+ \/ \d+ \/ \d+/
          puts "     div: #{val}"
          val
        end.compact
      end.transpose
    end.flatten(1).map {|k,v| [k.sub(":","").to_sym, v]}
  end

  private

  def urls
    Nokogiri::HTML(open(@base_url)).xpath("//urlset/url/loc").map { _1.content.strip }
  end
end
