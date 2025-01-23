require "spec_helper"

require_relative "../../app/burnside/parser"

RSpec.describe Burnside::Parser do
  subject { described_class.new(["spec/fixtures/burnside/agenda.html"]) }

  let(:expected) {
    {
      aanvang: "20:00 uur",
      datum: "24-01-2025",
      description: "Updated: 09-01-2025 20:00",
      eindtijd: "23:59 uur",
      geopend: "20:00 uur",
      locatie: "Burnside Park & Shop, Sint Olafstraat 6",
      title: "Valse start",
      url: "https://www.burnside.nl/agenda/__trashed/"
    }
  }

  before do
    Timecop.freeze(Time.local(2025, 1, 9, 20))
  end

  after do
    Timecop.return
  end

  describe ".call" do
    it { is_expected.to respond_to(:call) }

    it "parses file" do
      expect{
        described_class.call(["spec/fixtures/burnside/agenda_one.html"])
      }.not_to raise_error
      expect(described_class.call(["spec/fixtures/burnside/agenda_one.html"])).to eql([expected])
    end
  end

  describe "#call" do
    it "parses file" do
      expect(subject.call.size).to eql(5)
      expect { subject.call }.not_to raise_error
    end
  end
end
