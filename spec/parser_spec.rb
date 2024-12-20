require "spec_helper"

require_relative "../app/parser"

RSpec.describe Parser do
  subject { described_class.new("src/sitemap-test.xml") }

  let(:expected) {
    {
      datum: "za 21 sep 2024",
      locatie: "Concertzaal",
      geopend: "23:00 uur",
      aanvang: "23:00 uur",
      eindtijd: "04:00 uur",
      leeftijd: "16+",
      type: "",
      prijs: "â\u0082¬ 7,50",
      # ticket_link: "https://burgerweeshuis.stager.co/web/tickets/111436027",
    }
  }

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
        described_class.call("src/sitemap-test.xml")
      }.not_to raise_error
      expect(described_class.call("src/sitemap-test.xml")).to eql([expected])
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
      expect(subject.detail_content(node)).to eql([
        [:datum, "za 21 sep 2024"],
        [:locatie, "Concertzaal"],
        [:geopend, "23:00 uur"],
        [:aanvang, "23:00 uur"],
        [:eindtijd, "04:00 uur"],
        [:leeftijd, "16+"],
        [:type, ""],
        [:prijs, "â\u0082¬ 7,50"]
      ])
    end

    it "extracts data from detail_content block" do
      expect(Hash[subject.detail_content(node)]).to eql(expected)
    end
  end
end
