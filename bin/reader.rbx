#!/usr/bin/env  ruby
# https://deepinthecode.com/2016/03/22/using-ruby-to-get-all-links-from-a-sitemap-xml-file/
# ./reader.rbx  https://www.burgerweeshuis.nl/sitemap.xml
require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'

  gem 'sitemap-parser'
  gem 'wayback_archiver'
  gem 'open-uri'
  gem 'nokogiri'
end

require 'sitemap-parser'
require 'wayback_archiver'
require 'open-uri'
require 'nokogiri'

mainSitemapURL = ARGV[0]
if not mainSitemapURL.nil?
  puts 'Running...' #+ mainSitemapURL

  #mainSitemap = SitemapParser.new mainSitemapURL
  mainSitemap = Nokogiri::HTML(open(mainSitemapURL))
  #puts mainSitemap
  mainSitemap.xpath("//sitemap/loc").each do |node|
    #puts node.content
    subSitemapURL = node.content
    subSitemap = SitemapParser.new subSitemapURL
    arraySubSitemap = subSitemap.to_a
    (0..arraySubSitemap.length-1).each do |j|
      #puts arraySubSitemap[j]
      WaybackArchiver.archive(arraySubSitemap[j], :url)
    end
  end
end
puts 'Finished.'
