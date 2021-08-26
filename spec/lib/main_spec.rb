# frozen_string_literal: true

require 'spec_helper'

describe ::Main do
  subject do
    described_class.new(file, logs_reader: ::Files::Readers::LogReader, analyzers: analyzers)
  end

  let(:logs_reader) { instance_double(::Files::Readers::LogReader) }
  let(:analyzers) { %i[count uniq] }
  let(:reporter) { instance_double(::Reporters::Stdout) }
  let(:count_analyzer) { instance_double(::Analyzers::CountAnalyzer, call: count_stats) }
  let(:uniq_analyzer) { instance_double(::Analyzers::UniqAnalyzer, call: uniq_stats) }

  let(:file) { 'webserver.log' }
  let(:visits) { [visit1, visit2] }
  let(:visit1) { instance_double(::Datum::Visit) }
  let(:visit2) { instance_double(::Datum::Visit) }

  let(:count_stats) { 'count_stats' }
  let(:uniq_stats) { 'uniq_stats' }

  describe '.call' do
    before do
      expect(::Files::Readers::LogReader).to receive(:new).with(file).and_return(logs_reader)
      expect(logs_reader).to receive(:call).and_yield('/route2', 3).and_yield('/route1', 3)
      expect(::Datum::Visit).to receive(:new).with('/route2', 3).and_return(visit1)
      expect(::Datum::Visit).to receive(:new).with('/route1', 3).and_return(visit2)
      expect(::Analyzers::CountAnalyzer).to receive(:new).with(visits).and_return(count_analyzer)
      expect(::Analyzers::UniqAnalyzer).to receive(:new).with(visits).and_return(uniq_analyzer)
      expect(::Reporters::Stdout).to receive(:new).and_return(reporter).twice
    end

    it 'calls log reader, analyzes visits and reports' do
      expect(reporter).to receive(:call).with(count_stats)
      expect(reporter).to receive(:call).with(uniq_stats)

      subject.call
    end
  end

  describe 'DECORATORS_MAPPING' do
    it 'decorates count stats' do
      expect(described_class::DECORATORS_MAPPING.fetch(:count).call(['/route', 3])).to eq('/route 3 views')
    end

    it 'decorates uniq stats' do
      expect(described_class::DECORATORS_MAPPING.fetch(:uniq).call(['/route', 3])).to eq('/route 3 unique views')
    end
  end
end
