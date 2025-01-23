class Parser
  CUTOFF = (DateTime.now - 14) # minus 14 days

  def self.call(args)
    new(args).call
  end

  def initialize(args)
    @base_urls = args
  end
  attr_reader :base_urls

  private

  def normalize_time(time_str)
    time_str.sub("januari", "January")
      .sub("februari", "February")
      .sub("maart", "March")
      .sub("april", "April")
      .sub("mei", "May")
      .sub("juni", "June")
      .sub("juli", "July")
      .sub("augustus", "August")
      .sub("september", "September")
      .sub("oktober", "October")
      .sub("november", "November")
      .sub("december", "December")
  end

  def uri_open_headers
    {
      "User-Agent" => "Ruby/#{RUBY_VERSION}; Leon Berenschot; https://leipeleon.github.io/bwh-ical/",
      redirect: false
    }
  end
end
