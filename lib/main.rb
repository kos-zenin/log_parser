# frozen_string_literal: true

class Main
  ANALYZERS_MAPPING = {
    count: ::Analyzers::CountAnalyzer,
    uniq: ::Analyzers::UniqAnalyzer
  }.freeze

  DECORATORS_MAPPING = {
    count: ->((route, visits_count)) { [route, visits_count, visits_count == 1 ? 'view' : 'views'].join(' ') },
    uniq: ->((route, visits_count)) { [route, visits_count, 'unique', visits_count == 1 ? 'view' : 'views'].join(' ') }
  }.freeze

  def initialize(file, logs_reader: ::Files::Readers::LogReader, analyzers: [], reporter: ::Reporters::Stdout)
    @logs_reader = logs_reader.new(file)
    @analyzers = analyzers
    @reporter = reporter
  end

  def call
    collect_visits.then do |visits|
      @analyzers.each do |analyzer|
        reporter = @reporter.new(decorator: DECORATORS_MAPPING.fetch(analyzer))
        ANALYZERS_MAPPING.fetch(analyzer).new(visits).call.then { reporter.call(_1) }
      end
    end
  end

  private

  def collect_visits
    [].tap do |visits|
      @logs_reader.call do |route, ip|
        visits << ::Datum::Visit.new(route, ip)
      end
    end
  end
end
