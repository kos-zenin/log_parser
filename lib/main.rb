# frozen_string_literal: true

class Main
  ANALYZERS_MAPPING = {
    count: ::Analyzers::CountAnalyzer,
    uniq: ::Analyzers::UniqAnalyzer
  }.freeze

  def initialize(file, logs_reader: nil, analyzers: [], reporter: ::Reporters::Stdout.new)
    @logs_reader = logs_reader.new(file)
    @analyzers = analyzers
    @reporter = reporter
  end

  def call
    collect_visits.then do |visits|
      @analyzers.each do |analyzer|
        ANALYZERS_MAPPING.fetch(analyzer).new(visits).call.then { @reporter.call(_1) }
      end
    end
  end

  private

  def collect_visits
    @logs_reader.call do |route, ip|
      visits << ::Datum::Visit.new(route, ip)
    end
  end
end
