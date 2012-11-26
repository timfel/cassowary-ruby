$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

if ENV["coverage"]
  require "simplecov"
  SimpleCov.start do
    add_filter "/test/"
  end
end

require "test/unit"
require "cassowary"
