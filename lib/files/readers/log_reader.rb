# frozen_string_literal: true

module Files
  module Readers
    class LogReader
      WHITELIST_EXTENSIONS = %w[.log].freeze

      def initialize(file, file_proxy: File)
        @file = file
        @file_proxy = file_proxy
      end

      def call
        validate!(@file)

        open_file(@file).lazy.each do |line|
          yield line.split(' ')
        end
      end

      private

      def open_file(file)
        @file_proxy.open(file, 'rb')
      rescue Errno::EACCES, Errno::ENOENT
        raise ArgumentError, 'Check file permissions'
      end

      def validate!(file)
        raise ArgumentError, 'Check file extension' unless WHITELIST_EXTENSIONS.include?(@file_proxy.extname(file))
      end
    end
  end
end
