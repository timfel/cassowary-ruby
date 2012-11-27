$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

if ENV["coverage"]
  require "simplecov"
  SimpleCov.start do
    add_filter "/test/"
    minimum_coverage 90
  end
end

require "test/unit"
require "cassowary"
