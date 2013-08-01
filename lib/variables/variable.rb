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

    def begin_assign(v)
      @proposed_value_constraint = self == v
      SimplexSolver.instance.add_constraint(@proposed_value_constraint)
    end

    def assign
      SimplexSolver.instance.solve
    end

    def end_assign
      SimplexSolver.instance.remove_constraint(@proposed_value_constraint)
      @proposed_value_constraint = nil
    end
  end
end
