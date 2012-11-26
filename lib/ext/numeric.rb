# Copyright (C) 2012 by Tim Felgentreff

class Numeric
  include Cassowary::Equalities

  def as_linear_expression
    expr = Cassowary::LinearExpression.new
    expr.constant = self.to_f
    expr
  end
end
