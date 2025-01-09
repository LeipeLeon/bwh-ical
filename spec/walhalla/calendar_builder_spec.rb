
require "spec_helper"

require_relative "../../app/walhalla/calendar_builder.rb"

RSpec.describe Walhalla::CalendarBuilder do
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

  it "creates an ical feed" do
    expect {
      described_class.new([event]).call
    }.not_to raise_error
  end

  it "creates an ical feed" do
    expect {
      described_class.new(json).call
    }.not_to raise_error
  end
end
