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
      -1.0 * self
    end

    def inspect
      "#{super}[#{value.inspect}]"
    end
  end
end
