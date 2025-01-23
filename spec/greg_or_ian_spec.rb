# See: https://mikecoats.com/the-greg-or-ian-calendar/
require "spec_helper"

require_relative "../app/greg_or_ian.rb"

RSpec.describe GregOrIan do

  before { Timecop.freeze(Time.local(2025, 1, 23)) }
  after { Timecop.return }

  it "creates an ical feed" do
    expect(subject.call(1)).to eql <<~EVENT
      BEGIN:VCALENDAR\r
      VERSION:2.0\r
      PRODID:-//LeipeLeon//greg-or-ian-generator/\r
      CALSCALE:GREGORIAN\r
      X-APPLE-CALENDAR-COLOR:#BADA55\r
      X-WR-CALNAME:The Greg or Ian Calendar\r
      X-WR-CALDESC::Monday: Greg\\, Tuesday: Ian\\, Wednesday: Greg\\, Thursday: Ian\r
       \\, Friday: Greg\\, Saturday: Ian\\, Sunday: Greg. _The Gregorian calendar_\r
      X-ORIGINAL-URL:https://leipeleon.github.io/bwh-ical/\r
      BEGIN:VEVENT\r
      DTSTAMP:20250123T000000Z\r
      UID:LeipeLeon-greg-or-ian-generator-22-01-2025\r
      DTSTART;VALUE=DATE:20250122\r
      DESCRIPTION:See: https://mikecoats.com/the-greg-or-ian-calendar/\r
      SUMMARY:It's Ian day\r
      URL;VALUE=URI:https://mikecoats.com/the-greg-or-ian-calendar/\r
      END:VEVENT\r
      BEGIN:VEVENT\r
      DTSTAMP:20250123T000000Z\r
      UID:LeipeLeon-greg-or-ian-generator-23-01-2025\r
      DTSTART;VALUE=DATE:20250123\r
      DESCRIPTION:See: https://mikecoats.com/the-greg-or-ian-calendar/\r
      SUMMARY:It's Greg day\r
      URL;VALUE=URI:https://mikecoats.com/the-greg-or-ian-calendar/\r
      END:VEVENT\r
      BEGIN:VEVENT\r
      DTSTAMP:20250123T000000Z\r
      UID:LeipeLeon-greg-or-ian-generator-24-01-2025\r
      DTSTART;VALUE=DATE:20250124\r
      DESCRIPTION:See: https://mikecoats.com/the-greg-or-ian-calendar/\r
      SUMMARY:It's Ian day\r
      URL;VALUE=URI:https://mikecoats.com/the-greg-or-ian-calendar/\r
      END:VEVENT\r
      END:VCALENDAR\r
    EVENT
  end
end
