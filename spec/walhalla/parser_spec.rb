require "spec_helper"

require_relative "../../app/walhalla/parser"

RSpec.describe Walhalla::Parser do
  subject { described_class.new(["spec/fixtures/walhalla/upcoming_one.html"]) }

  let(:expected) {
    {
      aanvang: "20:00 uur",
      datum: "05-10-2024",
      description: "Updated: 09-01-2025 20:00",
      eindtijd: "00:00 uur",
      geopend: "20:00 uur",
      locatie: "Walhalla, Deventer",
      title: "Le Privet Social",
      url: "https://www.walhalla-deventer.nl/activiteit/le-privet-social-2/"
    }
  }

  before do
    Timecop.freeze(Time.local(2025, 1, 9, 20))
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
        described_class.call(["spec/fixtures/walhalla/upcoming_one.html"])
      }.not_to raise_error
      expect(described_class.call(["spec/fixtures/walhalla/upcoming_one.html"])).to eql([expected])
    end
  end

  describe "#call" do
    it "parses file" do
      expect { subject.call }.not_to raise_error
    end
  end
end
