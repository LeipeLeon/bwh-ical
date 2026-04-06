require "spec_helper"

require_relative "../../app/bwh/parser"

RSpec.describe Bwh::Parser do
  subject { described_class.new(["spec/fixtures/bwh/programma.html"]) }

  let(:expected_douwe_bob) {
    {
      datum: "09-04-2026",
      locatie: "Concertzaal",
      geopend: "19:30 uur",
      aanvang: "19:45 uur",
      eindtijd: "23:00 uur",
      leeftijd: "alle",
      title: "Douwe Bob try out",
      type: "",
      url: "https://www.burgerweeshuis.nl/events/douwe-bob",
      description: "Apr 09, 2026 \u2013 Douwe Bob is \u00e9\u00e9n van de meest markante singer-songwriters van Nederland. Tijdens deze try out zullen nummers van het nieuwe album voor het eerst live worden gespeeld.",
      prijs: "€ 35,-",
    }
  }

  let(:expected_science_cafe) {
    {
      datum: "08-04-2026",
      locatie: "Concertzaal",
      geopend: "19:30 uur",
      aanvang: "20:00 uur",
      eindtijd: "22:30 uur",
      leeftijd: "alle",
      title: "Science Café    ",
      type: "seated",
      url: "https://www.burgerweeshuis.nl/events/science-cafe-6",
      description: "Apr 08, 2026 \u2013 Een kring om de maan, het morgenrood, de regenboog: het zijn natuurverschijnselen die we allemaal wel eens hebben gezien. Maar wie kent de ring van Bishop, de bogen van Lowitz, de onderzon of de groene flits? Wat is een fata morgana? En hoe komt het dat de lucht blauw is?",
      prijs: "gratis",
    }
  }

  before do
    Timecop.freeze(Time.local(2026, 4, 6, 20))
  end

  after do
    Timecop.return
  end

  describe ".call" do
    before do
      stub_request(:get, /https:\/\/www.burgerweeshuis.nl\/events/)
        .to_return(status: 200, body: File.read('spec/fixtures/bwh/douwe-bob.html'))
    end

    it { is_expected.to respond_to(:call) }

    it "parses file" do
      expect{
        described_class.call(["spec/fixtures/bwh/programma.html"])
      }.not_to raise_error
    end
  end

  describe "#call" do
    before do
      stub_request(:get, /https:\/\/www.burgerweeshuis.nl\/events/)
        .to_return(status: 200, body: File.read('spec/fixtures/bwh/douwe-bob.html'))
    end

    it "parses file" do
      expect { subject.call }.not_to raise_error
    end
  end

  describe ".detail_content" do
    context "with missing type value (value div omitted from DOM)" do
      let(:node) { Nokogiri::HTML(File.read("spec/fixtures/bwh/douwe-bob.html", encoding: "UTF-8"), nil, "UTF-8").css(".detail_content").first }

      it "extracts data and aligns values correctly" do
        expect(subject.detail_content(node)).to eql([
          [:datum, "09-04-2026"],
          [:locatie, "Concertzaal"],
          [:geopend, "19:30 uur"],
          [:aanvang, "19:45 uur"],
          [:eindtijd, "23:00 uur"],
          [:leeftijd, "alle"],
          [:type, ""],
          [:prijs, "€ 35,-"]
        ])
      end
    end

    context "with type value present" do
      let(:node) { Nokogiri::HTML(File.read("spec/fixtures/bwh/science-cafe-6.html", encoding: "UTF-8"), nil, "UTF-8").css(".detail_content").first }

      it "extracts data from detail_content block" do
        expect(subject.detail_content(node)).to eql([
          [:datum, "08-04-2026"],
          [:locatie, "Concertzaal"],
          [:geopend, "19:30 uur"],
          [:aanvang, "20:00 uur"],
          [:eindtijd, "22:30 uur"],
          [:leeftijd, "alle"],
          [:type, "seated"],
          [:prijs, "gratis"]
        ])
      end
    end
  end
end
