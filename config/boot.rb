# frozen_string_literal: true

require 'zeitwerk'

APP_LOADER = Zeitwerk::Loader.for_gem
APP_LOADER.enable_reloading

%w[
  lib
].each(&APP_LOADER.method(:push_dir))

APP_LOADER.setup
