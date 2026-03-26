require "spec_helper"

require_relative "../../app/buitenpost/parser"

RSpec.describe Buitenpost::Parser do
  subject { described_class.new(["spec/fixtures/buitenpost/agenda.json"]) }

  let(:expected) {
    {
      datum: "09-05-2026",
      title: "Lentebierfestival",
      url: "https://bijbuitenpost.nl/lentebierfestival",
      description: "Het vijfde Lentebierfestival met 11 brouwers en meer dan 75 speciaalbieren.",
      locatie: "Landgoed Buitenpost, Rijksstraatweg 7, Twello"
    }
  }

  before do
    Timecop.freeze(Time.local(2026, 1, 9, 20))
  end

  after do
    Timecop.return
  end

  describe ".call" do
    it { is_expected.to respond_to(:call) }

    it "parses file" do
      expect {
        described_class.call(["spec/fixtures/buitenpost/agenda_one.json"])
      }.not_to raise_error
      expect(described_class.call(["spec/fixtures/buitenpost/agenda_one.json"])).to eql([expected])
    end
  end

  describe "#call" do
    it "parses file" do
      expect(subject.call.size).to eql(5)
      expect { subject.call }.not_to raise_error
    end

    it "sorts events by date" do
      dates = subject.call.map { |e| Date.parse(e[:datum]) }
      expect(dates).to eql(dates.sort)
    end

    it "expands relative URLs" do
      mudrun = subject.call.find { |e| e[:title].include?("Mudrun") }
      expect(mudrun[:url]).to start_with("https://bijbuitenpost.nl")
    end

    it "parses multi-day events" do
      paasbrunch = subject.call.find { |e| e[:title] == "Paasbrunch" }
      expect(paasbrunch[:datum]).to eql("05-04-2026")
    end
  end
end
