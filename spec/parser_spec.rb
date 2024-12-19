require "spec_helper"

require_relative "../app/parser"

RSpec.describe Parser do
  subject { described_class.new("src/sitemap-2024-12-19-1053.xml") }

  before do
    stub_request(:get, "https://www.burgerweeshuis.nl/events/40-jaar-club-hitsig")
      .to_return(status: 200, body: File.read('src/hitsig.html'))
  end

  describe ".call" do
    pending "responds to .call" do
      expect(subject).to respond_to?(:call)
    end

    it "parses file" do
      expect{
        described_class.call("src/sitemap-2024-12-19-1053.xml")
      }.not_to raise_error
    end
  end

  describe "#call" do
    it "parses file" do
      expect { subject.call }.not_to raise_error
    end
  end

  describe ".detail_content" do
    let(:node) { Nokogiri::HTML(open("src/detail_content.html")) }

    it "extracts data from detail_content block" do
      expect(subject.detail_content(node)).to eql(
        [
          [:datum, "vr 4 apr 2025"],
          [:locatie, "Concertzaal"],
          [:geopend, "19:30 uur"],
          [:aanvang, "20:00 uur"],
          [:eindtijd, "23:30 uur"],
          [:leeftijd, "alle"],
          [:type, ""],
          [:prijs, "â\u0082¬ 37,-"]
        ])
    end

    it "extracts data from detail_content block" do
      expect(Hash[subject.detail_content(node)]).to eql(
        {
          datum: "vr 4 apr 2025",
          locatie: "Concertzaal",
          geopend: "19:30 uur",
          aanvang: "20:00 uur",
          eindtijd: "23:30 uur",
          leeftijd: "alle",
          type: "",
          prijs: "â\u0082¬ 37,-",
          # ticket_link: "https://burgerweeshuis.stager.co/web/tickets/111436027",
        }
      )
    end
  end
end
