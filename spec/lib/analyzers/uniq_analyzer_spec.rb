# frozen_string_literal: true

require 'spec_helper'

describe ::Analyzers::UniqAnalyzer do
  subject { described_class.new(visits) }

  let(:visits) { [visit1, visit2, visit3, visit4, visit5, visit6] }
  let(:visit1) { instance_double(::Datum::Visit, route: '/route1', ip: '1.1.1.1') }
  let(:visit2) { instance_double(::Datum::Visit, route: '/route2', ip: '1.1.1.1') }
  let(:visit3) { instance_double(::Datum::Visit, route: '/route1', ip: '1.1.1.1') }
  let(:visit4) { instance_double(::Datum::Visit, route: '/route3', ip: '1.1.1.1') }
  let(:visit5) { instance_double(::Datum::Visit, route: '/route3', ip: '1.1.1.2') }
  let(:visit6) { instance_double(::Datum::Visit, route: '/route3', ip: '1.1.1.3') }

  describe '.call' do
    let(:expected_uniq_visits) do
      [
        ['/route3', 3],
        ['/route1', 1],
        ['/route2', 1]
      ]
    end

    it 'returns an array of ordered counted visits' do
      expect(subject.call).to eq(expected_uniq_visits)
    end
  end
end
