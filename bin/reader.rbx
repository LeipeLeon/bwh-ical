#!/usr/bin/env  ruby
# https://deepinthecode.com/2016/03/22/using-ruby-to-get-all-links-from-a-sitemap-xml-file/
# ./bin/reader.rbx
require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'

  gem 'open-uri'
  gem 'nokogiri'
  gem "icalendar"
  gem "base64"
end

require 'open-uri'
require 'nokogiri'
require 'json'

require './app/calendar_builder'
require './app/greg_or_ian.rb'

# create parent directory
FileUtils.mkdir_p("build/greg_or_ian")

File.open("build/greg_or_ian/events.ics", 'w') { |file| file.write(GregOrIan.new.call) }

## Burnside
begin
  puts "Burnside: Parsing"
  require './app/burnside/parser'
  urls = ["https://www.burnside.nl/agenda/"]

  # retrieve all events
  events = Burnside::Parser.call(urls).compact

  # create parent directory
  FileUtils.mkdir_p("build/burnside")

  # cache to disk
  File.open("build/burnside/events.json", 'w') { |file| file.write(JSON.pretty_generate(events)) }

  # build calendar
  calendar = CalendarBuilder.new(events).call

  File.open("build/burnside/events.ics", 'w') { |file| file.write(calendar) }
rescue Net::OpenTimeout
  puts "Timeout while trying to fetch Burnside events. Skipping."
end

## Walhalla
begin
  puts "Walhalla: Parsing"
  require './app/walhalla/parser'
  urls = [
    "https://www.walhalla-deventer.nl/activiteiten/afgelopen/?action=tribe_list&tribe_paged=1",
    "https://www.walhalla-deventer.nl/activiteiten/toekomstig/"
  ]

  # retrieve all events
  events = Walhalla::Parser.call(urls).compact

  # create parent directory
  FileUtils.mkdir_p("build/walhalla")

  # cache to disk
  File.open("build/walhalla/events.json", 'w') { |file| file.write(JSON.pretty_generate(events)) }

  # build calendar
  calendar = CalendarBuilder.new(events).call

  File.open("build/walhalla/events.ics", 'w') { |file| file.write(calendar) }

rescue Net::OpenTimeout
  puts "Timeout while trying to fetch Walhalla events. Skipping."
end

## BWH
begin
  puts "BWH: Parsing"
  require './app/bwh/parser'
  urls = ["https://www.burgerweeshuis.nl/programma"]

  # retrieve all events
  events = Bwh::Parser.call(urls).compact

  # create parent directory
  FileUtils.mkdir_p("build/bwh")

  # cache to disk
  File.open("build/bwh/events.json", 'w') { |file| file.write(JSON.pretty_generate(events)) }

  # build calendar
  calendar = CalendarBuilder.new(events).call

  File.open("build/bwh/events.ics", 'w') { |file| file.write(calendar) }
rescue Net::OpenTimeout
  puts "Timeout while trying to fetch BWH events. Skipping."
end
