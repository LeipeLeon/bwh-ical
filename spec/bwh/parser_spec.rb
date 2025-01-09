require "spec_helper"

require_relative "../../app/bwh/parser"

RSpec.describe Bwh::Parser do
  subject { described_class.new("spec/fixtures/bwh/programma.html") }

  let(:expected) {
    {
      datum: "21-09-2024",
      locatie: "Concertzaal",
      geopend: "23:00 uur",
      aanvang: "23:00 uur",
      eindtijd: "04:00 uur",
      leeftijd: "16+",
      title: "40 jaar Club: Hitsig",
      type: "",
      url: "https://www.burgerweeshuis.nl/events/boogie-nights-copy",
      description: "Updated: 09-01-2025 20:00\n\nSep 21, 2024 – Na een afwezigheid van 1778 dagen, 254 weken, 58,4 maanden, 4,87 jaren is het in het kader van 40 jaar Burger op 21 september eindelijk tijd voor een reünie van ons meest bekendste, vuigste, smerigste, sexy'ste, feestje ooit: HITSIG!!!!",
      prijs: "€ 7,50",
      # ticket_link: "https://burgerweeshuis.stager.co/web/tickets/111436027",
    }
  }

  before do
    Timecop.freeze(Time.local(2025, 1, 9, 20))
    stub_request(:get, /https:\/\/www.burgerweeshuis.nl\/events/)
      .to_return(status: 200, body: File.read('spec/fixtures/bwh/hitsig.html'))
  end

  after do
    Timecop.return
  end

  describe ".call" do
    pending "responds to .call" do
      expect(subject).to respond_to?(:call)
    end

    it "parses file" do
      expect{
        described_class.call("spec/fixtures/bwh/programma.html")
      }.not_to raise_error
      expect(described_class.call("spec/fixtures/bwh/programma.html").first).to eql(expected)
    end
  end

  describe "#call" do
    it "parses file" do
      expect { subject.call }.not_to raise_error
    end
  end

  describe ".detail_content" do
    let(:node) { Nokogiri::HTML(open("spec/fixtures/bwh/hitsig.html")).css(".detail_content") }

    it "extracts data from detail_content block" do
      expect(subject.detail_content(node)).to eql([
        [:datum, "21-09-2024"],
        [:locatie, "Concertzaal"],
        [:geopend, "23:00 uur"],
        [:aanvang, "23:00 uur"],
        [:eindtijd, "04:00 uur"],
        [:leeftijd, "16+"],
        [:type, ""],
        [:prijs, "€ 7,50"]
      ])
    end
  end
end
