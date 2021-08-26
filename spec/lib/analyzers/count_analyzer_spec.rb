# frozen_string_literal: true

require 'spec_helper'

describe ::Analyzers::CountAnalyzer do
  subject { described_class.new(visits) }

  let(:visits) { [visit1, visit2, visit3] }
  let(:visit1) { instance_double(::Datum::Visit, route: "/route1") }
  let(:visit2) { instance_double(::Datum::Visit, route: "/route2") }
  let(:visit3) { instance_double(::Datum::Visit, route: "/route1") }

  describe ".call" do
    let(:expected_counted_visits) do
      {
        "/route1" => 2,
        "/route2" => 1
      }
    end

    it "returns array of counted visits" do
      expect(subject.call).to eq(expected_counted_visits)
    end
  end
end
