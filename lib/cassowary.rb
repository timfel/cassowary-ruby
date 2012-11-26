# Copyright (C) 2012 by Tim Felgentreff

module Cassowary
  VERSION = "0.5.0"

  class Error < StandardError; end
  class InternalError < Error; end
  class NonLinearResult < Error; end
  class NotEnoughStays < Error; end
  class RequiredFailure < Error; end
  class TooDifficult < Error; end
end

require "utils/equalities"

require "variables"
require "constraint"
require "symbolic_weight"
require "strength"
require "linear_expression"
require "simplex_solver"

require "ext/object"
require "ext/float"
require "ext/numeric"
