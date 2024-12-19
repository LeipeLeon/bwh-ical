#!/usr/bin/env  ruby
# https://deepinthecode.com/2016/03/22/using-ruby-to-get-all-links-from-a-sitemap-xml-file/
# ./bin/reader.rbx  https://www.burgerweeshuis.nl/sitemap.xml
require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'

  gem 'open-uri'
  gem 'nokogiri'
end

require 'open-uri'
require 'nokogiri'

mainSitemapURL = ARGV[0]
if not mainSitemapURL.nil?
  puts 'Running...' #+ mainSitemapURL

  #mainSitemap = SitemapParser.new mainSitemapURL
  mainSitemap = Nokogiri::HTML(open(mainSitemapURL))
  # puts mainSitemap
  urls = []
  mainSitemap.xpath("//urlset/url/loc").each do |node|
    urls << node.content.strip
  end
  urls.each do |url|
    next unless url =~ /\/events\//
    puts url
    doc = Nokogiri::HTML(URI.open(url))
    # pp doc.xpath("//div[@class='detail_date w-condition-invisible']").map { _1.content }
    # pp doc.xpath("//div[@class='detail_content']").count

    doc.xpath("//div[@class='detail_content']").each do |node|
      pp node.content.inspect
    end
    break
  end
end


# ./src/hitsig.html
