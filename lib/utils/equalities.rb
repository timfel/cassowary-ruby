# Copyright (C) 2012 by Tim Felgentreff

module Cassowary
  module Equalities
    def ==(expr, strength = Strength::RequiredStrength, weight = 1.0)
      cn_equality(LinearEquation, self - expr, strength, weight)
    end

    def >=(expr, strength = Strength::RequiredStrength, weight = 1.0)
      cn_equality(LinearInequality, self - expr, strength, weight)
    end

    def >(expr, strength = Strength::RequiredStrength, weight = 1.0)
      cn_equality(LinearInequality, self - (expr + 1), strength, weight)
    end

    def <=(expr, strength = Strength::RequiredStrength, weight = 1.0)
      expr = expr.as_linear_expression if expr.is_a?(Numeric)
      cn_equality(LinearInequality, expr - self, strength, weight)
    end

    def <(expr, strength = Strength::RequiredStrength, weight = 1.0)
      expr = expr.is_a?(Numeric) ? (expr - 1).as_linear_expression : (expr - 1)
      cn_equality(LinearInequality, expr - self, strength, weight)
    end

    private
    def cn_equality(klass, expr, strength, weight)
      cn = klass.new
      cn.expression = expr
      cn.strength = strength
      cn.weight = weight
      cn
    end
  end
end
