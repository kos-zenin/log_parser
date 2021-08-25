# frozen_string_literal: true

require 'spec_helper'

describe ::Files::Readers::LogReader do
  subject { described_class.new(file, file_proxy: test_file_proxy) }

  let(:file) { instance_double(File) }
  let(:test_file_proxy) { class_double(File, extname: file_extension, open: open_file) }
  let(:file_extension) { '.log' }
  let(:open_file) { instance_double(File, lazy: lazy_enumerator) }
  let(:lazy_enumerator) { instance_double(Enumerator::Lazy) }

  describe 'call' do
    context "when file doesn't exist" do
      before do
        expect(test_file_proxy).to receive(:open).with(file, 'rb').and_raise(Errno::ENOENT)
      end

      it 'raises argument error' do
        expect { subject.call }.to raise_exception(ArgumentError)
      end
    end

    context 'when wrong file extension' do
      let(:file_extension) { '.csv' }

      it 'raises argument error' do
        expect { subject.call }.to raise_exception(ArgumentError)
      end
    end

    context 'when permission denied' do
      before do
        expect(test_file_proxy).to receive(:open).with(file, 'rb').and_raise(Errno::EACCES)
      end

      it 'raises argument error' do
        expect { subject.call }.to raise_exception(ArgumentError)
      end
    end

    context 'when file is ok' do
      let(:expected_lines) { [['line', '1'], ['line', '2']] }

      before do
        expect(lazy_enumerator).to receive(:each).and_yield("line 1").and_yield("line 2")
      end

      it 'yields line by line' do
        lines = []

        subject.call do |line|
          lines << line
        end

        expect(lines).to eq(expected_lines)
      end
    end
  end
end
