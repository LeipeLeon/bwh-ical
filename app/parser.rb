class Parser
  CUTOFF = (DateTime.now - 14) # minus 14 days

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

  def events
    @base_urls.map do |url|
      Nokogiri::HTML(URI.open(url, **uri_open_headers)).xpath("//article").map { _1 }
    end.flatten
  end

  def uri_open_headers
    {
      "User-Agent" => "Ruby/#{RUBY_VERSION}; Leon Berenschot; https://leipeleon.github.io/bwh-ical/",
      redirect: false
    }
  end
end
