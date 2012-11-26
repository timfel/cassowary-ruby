# Copyright (C) 2012 by Tim Felgentreff

module Cassowary
  class LinearExpression
    include Equalities

    attr_accessor :constant, :terms

    def self.new_with_symbolic_weight
      result = self.new
      result.constant = SymbolicWeight::Zero
      result
    end

    def initialize
      self.constant = 0.0
      self.terms = {}
    end

    def any_variable
      if terms.any?
        terms.keys.first
      else
        raise InternalError, "expression is constant"
      end
    end

    def as_linear_expression
      self
    end

    def coefficient_for(variable)
      terms[variable] || 0.0
    end

    def constant?
      terms.empty?
    end

    def each_variable_and_coefficient(&block)
      terms.each_pair(&block)
    end

    def add_variable(variable, coefficient, subject = nil, solver = nil)
      if terms.has_key? variable
        new_coeff = coefficient + terms[variable]
        if new_coeff.cl_approx_zero
          terms.delete variable
          solver.note_removed_variable(variable, subject) if solver
        else
          terms[variable] = new_coeff
        end
      else
        terms[variable] = coefficient
        solver.note_added_variable(variable, subject) if solver
      end
    end

    def add_expression(expr, times, subject = nil, solver = nil)
      increment_constant(times * expr.constant)
      expr.each_variable_and_coefficient do |v, c|
        add_variable(v, times * c, subject, solver)
      end
    end

    def new_subject(subject)
      nreciprocal = -(1.0 / terms.delete(subject))
      self.constant *= nreciprocal
      terms.each_pair do |v, c|
        terms[v] = c * nreciprocal
      end
    end

    def change_subject(old, new)
      reciprocal = 1.0 / terms.delete(new)
      nreciprocal = -reciprocal
      self.constant *= nreciprocal
      terms.each_pair do |v, c|
        terms[v] = c * nreciprocal
      end
      terms[old] = reciprocal
    end

    def increment_constant(num)
      self.constant += num
    end

    def substitute_variable(var, expr, subject, solver)
      multiplier = terms.delete(var)
      increment_constant(multiplier * expr.constant)
      expr.each_variable_and_coefficient do |v, c|
        if old_coeff = terms[v]
          new_coeff = old_coeff + (multiplier * c)
          if new_coeff.cl_approx_zero
            terms.delete v
            solver.note_removed_variable v, subject
          else
            terms[v] = new_coeff
          end
        else
          terms[v] = multiplier * c
          solver.note_added_variable v, subject
        end
      end
    end

    def *(x)
      return x * constant if constant?

      n = if x.is_a? Numeric
            x.to_f
          else
            expr = x.as_linear_expression
            raise NonLinearResult unless expr.constant?
            expr.constant
          end
      result = LinearExpression.new
      result.constant = n * constant
      terms.each_pair do |v, c|
        result.terms[v] = n * c
      end
      result
    end

    def /(x)
      expr = x.as_linear_expression
      raise NonLinearResult unless expr.constant?
      self * (1.0 / expr.constant)
    end

    def +(x)
      expr = x.as_linear_expression
      result = LinearExpression.new
      result.constant = constant + expr.constant
      terms.each_pair do |v, c|
        result.terms[v] = c
      end
      expr.each_variable_and_coefficient do |v, c|
        result.add_variable(v, c)
      end
      result
    end

    def -(x)
      expr = x.as_linear_expression
      result = LinearExpression.new
      result.constant = constant - expr.constant
      terms.each_pair do |v, c|
        result.terms[v] = c
      end
      expr.each_variable_and_coefficient do |v, c|
        result.add_variable(v, -c)
      end
      result
    end

    def inspect
      terms.keys.inject(constant.inspect) do |str, v|
        "#{str}+#{terms[v].inspect}*#{v.inspect}"
      end
    end
  end
end
