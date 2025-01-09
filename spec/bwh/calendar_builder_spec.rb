
require "spec_helper"

require_relative "../../app/bwh/calendar_builder.rb"

RSpec.describe Bwh::CalendarBuilder do
  let(:event) {
    {
      datum: "za 21 sep 2024",
      locatie: "Concertzaal",
      geopend: "23:00 uur",
      aanvang: "23:00 uur",
      eindtijd: "04:00 uur",
      leeftijd: "16+",
      title: "40 jaar Club: Hitsig",
      type: "",
      prijs: "€ 7,50",
      # ticket_link: "https://burgerweeshuis.stager.co/web/tickets/111436027",
    }
  }
  let(:json) { JSON.parse(File.read('spec/fixtures/bwh/events.json'), symbolize_names: true) }

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
