# frozen_string_literal: true

module Analyzers
  class CountAnalyzer
    def initialize(visits)
      @visits = visits
    end

    def call
      @visits.each_with_object(Hash.new(0)) do |visit, memo|
        memo[visit.route] += 1
      end
    end
  end
end
