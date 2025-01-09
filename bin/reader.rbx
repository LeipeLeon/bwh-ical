#!/usr/bin/env  ruby
# https://deepinthecode.com/2016/03/22/using-ruby-to-get-all-links-from-a-sitemap-xml-file/
# ./bin/reader.rbx
require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'

  gem 'open-uri'
  gem 'nokogiri'
  gem "icalendar"
end

require 'open-uri'
require 'nokogiri'

require './app/bwh/parser'
require './app/bwh/calendar_builder'
require 'json'

## BWH
url = "https://www.burgerweeshuis.nl/sitemap.xml"

# retrieve all events
events = Bwh::Parser.call(url).compact

# cache to disk
File.open("build/bwh/events.json", 'w') { |file| file.write(events.to_json) }

# build calendar
calendar = Bwh::CalendarBuilder.new(events).call

File.open("build/bwh/events.ics", 'w') { |file| file.write(calendar) }
