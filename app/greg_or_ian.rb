require "icalendar"

class GregOrIan
  GREG_OR_IAN = ["Ian", "Greg"]

  def call(width = 21)
    cal = Icalendar::Calendar.new
    cal.prodid = "-//LeipeLeon//greg-or-ian-generator/"
    cal.append_custom_property "X_APPLE_CALENDAR_COLOR", "#BADA55"
    cal.append_custom_property "X_WR_CALNAME", "The Greg or Ian Calendar"
    cal.append_custom_property "X_WR_CALDESC:", "Monday: Greg, Tuesday: Ian, Wednesday: Greg, Thursday: Ian, Friday: Greg, Saturday: Ian, Sunday: Greg. _The Gregorian calendar_"
    cal.append_custom_property "X_ORIGINAL_URL", "https://leipeleon.github.io/bwh-ical/"
    (Date.today - width).step(Date.today + width).map do |date|
      its_greg_or_ian = GREG_OR_IAN[date.strftime("%w").to_i % 2]
      event             = Icalendar::Event.new
      event.dtstart     = Icalendar::Values::Date.new(date)
      event.summary     = "It's #{its_greg_or_ian} day"
      event.description = "See: https://mikecoats.com/the-greg-or-ian-calendar/"
      event.url         = "https://mikecoats.com/the-greg-or-ian-calendar/"
      event.uid         = "LeipeLeon-greg-or-ian-generator-%s" % date.strftime("%d-%m-%Y")

      cal.add_event(event)
    end
    cal.to_ical
  end
end
