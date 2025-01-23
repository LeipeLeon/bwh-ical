require "icalendar"

class CalendarBuilder
  def initialize(events)
    @events = events
  end

  def call
    @cal = Icalendar::Calendar.new
    @cal.timezone do |t|
      t.tzid = "Europe/Amsterdam"

      t.daylight do |d|
        d.tzoffsetfrom = "+0100"
        d.tzoffsetto   = "+0200"
        d.tzname       = "GMT+02:00"
        d.dtstart      = "19810329T020000"
        d.rrule        = "FREQ=YEARLY;BYMONTH=3;BYDAY=-1SU"
      end

      t.standard do |s|
        s.tzoffsetfrom = "+0200"
        s.tzoffsetto   = "+0100"
        s.tzname       = "GMT+01:00"
        s.dtstart      = "19961027T030000"
        s.rrule        = "FREQ=YEARLY;BYMONTH=10;BYDAY=-1SU"
      end
    end

    for calendar_event in @events
      begin
        dtstart = DateTime.parse([
          calendar_event[:datum],
          calendar_event[:geopend]&.sub(" uur", "")
        ].join(" "))
        dtend = DateTime.parse([
          calendar_event[:datum],
          calendar_event[:eindtijd]&.sub(" uur", "")
        ].join(" "))

        if dtend < dtstart
          dtend = dtend + 1
        end

        event             = Icalendar::Event.new
        if calendar_event[:geopend]
          event.dtstart     = Icalendar::Values::DateTime.new(dtstart)
          event.dtend       = Icalendar::Values::DateTime.new(dtend)
        else
          event.transp = 'TRANSPARENT'
          dtend = dtstart + 1
          event.dtstart     = Icalendar::Values::Date.new(dtstart)
          event.dtend       = Icalendar::Values::Date.new(dtend)
        end
        event.summary     = calendar_event[:title]
        event.description = calendar_event[:description]
        event.url         = calendar_event[:url]
        event.uid         = calendar_event[:url]
        event.location    = calendar_event[:locatie]
        event.dtstart.ical_params = { "TZID" => 'Europe/Amsterdam' }
        event.dtend.ical_params   = { "TZID" => 'Europe/Amsterdam' }

        @cal.add_event(event)
      rescue
        pp calendar_event
        raise
      end
    end
    @cal.to_ical
  end
end
