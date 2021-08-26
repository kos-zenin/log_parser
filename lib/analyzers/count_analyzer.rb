# frozen_string_literal: true

module Analyzers
  class CountAnalyzer
    def initialize(visits)
      @visits = visits
    end

    def call
      @visits
        .each_with_object(Hash.new(0)) { |visit, memo| memo[visit.route] += 1 }
        .sort_by { |_, number_of_visits| -number_of_visits }
    end
  end
end
