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

require './app/parser'
require 'json'

url = ARGV[0] || "https://www.burgerweeshuis.nl/sitemap.xml"

# retrieve all events
events = Parser.call(url).compact

# cache to disk
File.open("scratch/events.json", 'w') { |file| file.write(events.to_json) }

