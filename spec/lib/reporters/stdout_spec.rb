# frozen_string_literal: true

require 'spec_helper'

describe ::Reporters::Stdout do
  subject { described_class.new(decorator: decorator) }

  let(:messages) { ['first line', 'second_line'] }

  let(:decorator) { ->(message) { "formatted #{message}" } }

  describe 'call' do
    it 'prints messages to stdout' do
      expect(subject).to receive(:puts).with(['formatted first line', 'formatted second_line'])

      subject.call(messages)
    end
  end
end
