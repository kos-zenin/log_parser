# frozen_string_literal: true

class Main
  def initialize(file, logs_reader: nil, analyzers: [], reporter: nil)
    @file = file
    @logs_reader = logs_reader
    @analyzers = analyzers
    @reporter = reporter
  end

  def call; end
end
