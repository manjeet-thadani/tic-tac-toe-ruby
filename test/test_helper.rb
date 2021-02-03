# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "t3_mt"

require "minitest/autorun"
require "minitest/reporters"
Minitest::Reporters.use!
