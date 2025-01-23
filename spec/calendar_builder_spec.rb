
require "spec_helper"

require_relative "../app/calendar_builder.rb"

RSpec.describe CalendarBuilder do
  let(:event) {
    {
      aanvang: "20:00 uur",
      datum: "11-01-2025",
      description: "Updated: 09-01-2025 20:00",
      eindtijd: "00:00 uur",
      geopend: "20:00 uur",
      title: "Le Privet Social",
      url: "https://www.walhalla-deventer.nl/activiteit/le-privet-social-2/"
    }
  }
  let(:json) { JSON.parse(File.read('spec/fixtures/walhalla/events.json'), symbolize_names: true) }

  before { Timecop.freeze(Time.local(2025, 1, 9, 20)) }
  after { Timecop.return }

  it "creates an ical feed" do
    expect {
      described_class.new([event]).call
    }.not_to raise_error
  end

  it "creates an ical feed" do
    expect(described_class.new([event]).call.gsub("\r\n","\n")).to eql <<~EVENT
      BEGIN:VCALENDAR
      VERSION:2.0
      PRODID:icalendar-ruby
      CALSCALE:GREGORIAN
      BEGIN:VTIMEZONE
      TZID:Europe/Amsterdam
      BEGIN:DAYLIGHT
      DTSTART:19810329T020000
      TZOFFSETFROM:+0100
      TZOFFSETTO:+0200
      RRULE:FREQ=YEARLY;BYDAY=-1SU;BYMONTH=3
      TZNAME:GMT+02:00
      END:DAYLIGHT
      BEGIN:STANDARD
      DTSTART:19961027T030000
      TZOFFSETFROM:+0200
      TZOFFSETTO:+0100
      RRULE:FREQ=YEARLY;BYDAY=-1SU;BYMONTH=10
      TZNAME:GMT+01:00
      END:STANDARD
      END:VTIMEZONE
      BEGIN:VEVENT
      DTSTAMP:20250109T200000Z
      UID:https://www.walhalla-deventer.nl/activiteit/le-privet-social-2/
      DTSTART;TZID=Europe/Amsterdam:20250111T200000
      DTEND;TZID=Europe/Amsterdam:20250112T000000
      DESCRIPTION:Updated: 09-01-2025 20:00
      SUMMARY:Le Privet Social
      URL;VALUE=URI:https://www.walhalla-deventer.nl/activiteit/le-privet-social-
       2/
      END:VEVENT
      END:VCALENDAR
    EVENT
  end

  context "all day event" do
    let(:event) {
      {
        "datum": "15-03-2025",
        "title": "SNEEUWTRIP 2025 FLAINE",
        "url": "https://www.burnside.nl/agenda/sneeuwtrip-2025-natuurlijk-naar-flaine/",
        "description": "Updated: 23-01-2025 11:41",
        "locatie": "Burnside Park & Shop, Sint Olafstraat 6"
      }
    }

    it "creates an ical feed" do
      expect(described_class.new([event]).call.gsub("\r\n","\n")).to eql <<~EVENT
        BEGIN:VCALENDAR
        VERSION:2.0
        PRODID:icalendar-ruby
        CALSCALE:GREGORIAN
        BEGIN:VTIMEZONE
        TZID:Europe/Amsterdam
        BEGIN:DAYLIGHT
        DTSTART:19810329T020000
        TZOFFSETFROM:+0100
        TZOFFSETTO:+0200
        RRULE:FREQ=YEARLY;BYDAY=-1SU;BYMONTH=3
        TZNAME:GMT+02:00
        END:DAYLIGHT
        BEGIN:STANDARD
        DTSTART:19961027T030000
        TZOFFSETFROM:+0200
        TZOFFSETTO:+0100
        RRULE:FREQ=YEARLY;BYDAY=-1SU;BYMONTH=10
        TZNAME:GMT+01:00
        END:STANDARD
        END:VTIMEZONE
        BEGIN:VEVENT
        DTSTAMP:20250109T200000Z
        UID:https://www.burnside.nl/agenda/sneeuwtrip-2025-natuurlijk-naar-flaine/
        DTSTART;TZID=Europe/Amsterdam:20250315T000000
        DTEND;TZID=Europe/Amsterdam:20250316T000000
        DESCRIPTION:Updated: 23-01-2025 11:41
        LOCATION:Burnside Park & Shop\\, Sint Olafstraat 6
        SUMMARY:SNEEUWTRIP 2025 FLAINE
        TRANSP:TRANSPARENT
        URL;VALUE=URI:https://www.burnside.nl/agenda/sneeuwtrip-2025-natuurlijk-naa
         r-flaine/
        END:VEVENT
        END:VCALENDAR
      EVENT
    end
  end

  it "creates an ical feed" do
    expect {
      described_class.new(json).call
    }.not_to raise_error
  end
end
