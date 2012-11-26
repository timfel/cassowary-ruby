# Copyright (C) 2012 by Tim Felgentreff

module Cassowary
  class LinearConstraint < Constraint
    attr_accessor :expression
  end

  class LinearEquation < LinearConstraint
    def inspect
      "#{strength.inspect}(#{expression.inspect}=0)"
    end
  end

  class LinearInequality < LinearConstraint
    def inequality?
      true
    end

    def inspect
      "#{strength.inspect}(#{expression.inspect}>=0)"
    end
  end
end
