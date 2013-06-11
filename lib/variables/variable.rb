# Copyright (C) 2012 by Tim Felgentreff

module Cassowary
  class Variable < AbstractVariable
    include Equalities

    attr_accessor :value

    def initialize(hash)
      super
      self.value = hash[:value]
    end

    def *(expr)
      self.as_linear_expression * expr
    end

    def +(expr)
      self.as_linear_expression + expr
    end

    def -(expr)
      self.as_linear_expression - expr
    end

    def /(expr)
      self.as_linear_expression / expr
    end

    def as_linear_expression
      expr = LinearExpression.new
      expr.terms[self] = 1.0
      expr
    end

    def external?
      true
    end

    def pivotable?
      false
    end

    def restricted?
      false
    end

    def -@
      -1.0.as_linear_expression * self
    end

    def inspect
      "#{super}[#{value.inspect}]"
    end

    def stay(strength = :strong)
      Cassowary::SimplexSolver.instance.add_stay(self, Cassowary.symbolic_strength(strength))
      self
    end

    def suggest_value(v)
      # SimplexSolver.instance.add_edit_var(self, Strength::StrongStrength)
      # SimplexSolver.instance.begin_edit
      c = self == v
      SimplexSolver.instance.add_constraint(c)
      # SimplexSolver.instance.suggest_value(self, v)
      SimplexSolver.instance.solve
      SimplexSolver.instance.remove_constraint(c)
      # SimplexSolver.instance.end_edit
    end
  end
end
