# Copyright (C) 2012 by Tim Felgentreff

module Cassowary
  class EditOrStayConstraint < Constraint
    attr_accessor :variable

    def initialize(hash = {})
      hash = {:weight => 1.0}.merge(hash)
      self.variable = hash[:variable]
      self.strength = hash[:strength]
      self.weight = hash[:weight]
    end

    def expression
      e = LinearExpression.new
      e.constant = variable.value
      e.terms[variable] = -1.0
      e
    end
  end

  class EditConstraint < EditOrStayConstraint
    attr_accessor :value

    def initialize(hash = {})
      super
      self.value = hash[:value]
    end

    def edit_constraint?
      true
    end
  end

  class StayConstraint < EditOrStayConstraint
    def stay_constraint?
      true
    end
  end
end
