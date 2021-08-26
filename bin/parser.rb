#!/usr/bin/env ruby
# frozen_string_literal: true

abort("correct usage is 'bin/bundle webserver.log'") unless ARGV[0]

require_relative './../config/boot'

::Main.new(ARGV[0], analyzers: %i[count uniq]).call
