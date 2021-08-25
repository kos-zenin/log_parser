# frozen_string_literal: true

require 'spec_helper'

describe ::Datum::Visit do
  subject { described_class.new(route, ip) }

  let(:route) { '/test/2' }
  let(:ip) { '1.1.1.1' }

  describe "route" do
    it "should return route" do
      expect(subject.route).to eq(route)
    end
  end

  describe "ip" do
    it "should return ip" do
      expect(subject.ip).to eq(ip)
    end
  end

  describe 'valid?' do
    context 'when route and ip has valid format' do
      it 'returns true' do
        expect(subject.valid?).to be_truthy
      end
    end

    context 'when route has invalid format' do
      let(:route) { 'route' }

      it 'returns false' do
        expect(subject.valid?).to be_falsey
      end
    end

    context 'when ip has invalid format' do
      let(:ip) { '2001:db8:85a3::8a2e:370:7334' }

      it 'returns false' do
        expect(subject.valid?).to be_falsey
      end
    end
  end
end
