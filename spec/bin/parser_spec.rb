# frozen_string_literal: true

describe 'parse' do
  context 'integration tests' do
    context 'when no argument were provided' do
      it 'writes to stderr an error' do
        expect do
          system('bin/parser.rb')
        end.to output("correct usage is 'bin/bundle webserver.log'\n").to_stderr_from_any_process
      end
    end

    context 'when correct arguments' do
      let(:expected_output) do
        %(
          /about/2 90 views
          /contact 89 views
          /index 82 views
          /about 81 views
          /help_page/1 80 views
          /home 78 views
          /contact 23 unique views
          /index 23 unique views
          /help_page/1 23 unique views
          /home 23 unique views
          /about/2 22 unique views
          /about 21 unique views
        )
      end

      it 'runs the script' do
        expect { system('bin/parser.rb spec/files/webserver.log') }.to output(expected_output).to_stdout_from_any_process
      end
    end
  end
end
