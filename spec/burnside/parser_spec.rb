require "spec_helper"

require_relative "../../app/burnside/parser"

RSpec.describe Burnside::Parser do
  subject { described_class.new(["spec/fixtures/burnside/agenda.html"]) }

  let(:expected) {
    {
      datum: "30-05-2025",
      description: "Updated: 09-01-2025 20:00",
      locatie: "Burnside Park & Shop, Sint Olafstraat 6",
      title: "Burnside cafÃ© â\u0080\u0093 Zomer programma vrijdag 30 mei â\u0080\u0093 Nic Frederick",
      url: "https://www.burnside.nl/agenda/burnside-cafe-zomer-programma-vrijdag-30-mei-nic-frederick/"
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
      expect(subject.call.size).to eql(6)
      expect { subject.call }.not_to raise_error
    end
  end
end
