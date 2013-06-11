# Copyright (C) 2012 by Tim Felgentreff

module Cassowary
  class Constraint < ConstraintObject
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

    def enable(strength=:required)
      self.strength = Cassowary.symbolic_strength(strength)
      SimplexSolver.instance.add_constraint(self)
      Cassowary::SimplexSolver.instance.solve
    end

    def disable
      SimplexSolver.instance.remove_constraint(self)
    end
  end
end

require "constraint/edit_or_stay_constraint"
require "constraint/linear_constraint"
