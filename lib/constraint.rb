# Copyright (C) 2012 by Tim Felgentreff

module Cassowary
  class Constraint
    attr_accessor :strength, :weight

    def expression
      raise NotImplementedError, "my subclass should have implemented #expression"
    end

    def edit_constraint?
      false
    end

    def inequality?
      false
    end

    def required?
      strength.required?
    end

    def stay_constraint?
      false
    end
  end
end

require "constraint/edit_or_stay_constraint"
require "constraint/linear_constraint"
