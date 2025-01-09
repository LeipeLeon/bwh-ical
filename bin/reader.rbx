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
require 'json'
require 'enhanced_errors'
require 'awesome_print' # Optional, for better output

require './app/walhalla/parser'
require './app/walhalla/calendar_builder'

## Walhalla
urls = [
  "https://www.walhalla-deventer.nl/activiteiten/afgelopen/?action=tribe_list&tribe_paged=1",
  "https://www.walhalla-deventer.nl/activiteiten/toekomstig/"
]

# retrieve all events
events = Walhalla::Parser.call(urls).compact

# create parent directory
FileUtils.mkdir_p("build/walhalla")

# cache to disk
File.open("build/walhalla/events.json", 'w') { |file| file.write(events.to_json) }

# build calendar
calendar = Walhalla::CalendarBuilder.new(events).call

File.open("build/walhalla/events.ics", 'w') { |file| file.write(calendar) }

require './app/bwh/parser'
require './app/bwh/calendar_builder'

## BWH
url = "https://www.burgerweeshuis.nl/programma"

# retrieve all events
events = Bwh::Parser.call(url).compact

# create parent directory
FileUtils.mkdir_p("build/bwh")

# cache to disk
File.open("build/bwh/events.json", 'w') { |file| file.write(events.to_json) }

# build calendar
calendar = Bwh::CalendarBuilder.new(events).call

File.open("build/bwh/events.ics", 'w') { |file| file.write(calendar) }
