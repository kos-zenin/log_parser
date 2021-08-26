# frozen_string_literal: true

module Reporters
  class Stdout
    def initialize(decorator: ->(message) { message })
      @decorator = decorator
    end

    def call(messages)
      puts(messages.map { @decorator.call(_1) })
    end
  end
end
