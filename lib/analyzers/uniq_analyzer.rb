# frozen_string_literal: true

module Analyzers
  class UniqAnalyzer
    def initialize(visits)
      @visits = visits
    end

    def call
      aggregate_visits
        .transform_values { |ips| ips.uniq.size }
        .sort_by { |_, number_of_visits| -number_of_visits }
    end

    private

    def aggregate_visits
      @visits.each_with_object({}) do |visit, memo|
        memo[visit.route] ||= []
        memo[visit.route] << visit.ip
      end
    end
  end
end
