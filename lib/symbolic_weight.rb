# Copyright (C) 2012 by Tim Felgentreff

module Cassowary
  class SymbolicWeight
    include Enumerable
    include Comparable

    StrengthLevels = 3

    def initialize(levels = {})
      @levels = [0.0] * StrengthLevels
      case levels
      when Hash
        levels.each_pair do |k, v|
          @levels[k - 1] = v
        end
      when Array
        levels.each_with_index do |e, idx|
          @levels[idx - 1] = e
        end
      else
        raise InternalError
      end
    end

    def each(*args, &block)
      @levels.each(*args, &block)
    end

    def [](idx)
      @levels[idx]
    end

    def []=(idx, value)
      @levels[idx] = value
    end

    def *(n)
      raise InternalError unless n.is_a? Numeric
      result = SymbolicWeight.new
      each_with_index do |e, idx|
        result[idx] = e * n
      end
      result
    end

    def /(n)
      raise InternalError unless n.is_a? Numeric
      result = SymbolicWeight.new
      each_with_index do |e, idx|
        result[idx] = e / n
      end
      result
    end

    def +(n)
      raise InternalError unless n.is_a? SymbolicWeight
      result = SymbolicWeight.new
      each_with_index do |e, idx|
        result[idx] = e + n[idx]
      end
      result
    end

    def -(n)
      raise InternalError unless n.is_a? SymbolicWeight
      result = SymbolicWeight.new
      each_with_index do |e, idx|
        result[idx] = e - n[idx]
      end
      result
    end

    def <=>(other)
      return nil unless other.is_a? SymbolicWeight
      each_with_index do |e, idx|
        return -1 if e < other[idx]
        return 1 if e > other[idx]
      end
      0
    end

    def cl_approx(s)
      raise InternalError unless s.is_a? SymbolicWeight
      each_with_index do |e, idx|
        return false unless e.cl_approx(s[idx])
      end
      true
    end

    def cl_approx_zero
      cl_approx Zero
    end

    def definitely_negative
      epsilon = SimplexSolver::Epsilon
      nepsilon = 0.0 - epsilon
      each do |e|
        return true if e < nepsilon
        return false if e > epsilon
      end
      false
    end

    def symbolic_weight?
      true
    end

    def inspect
      "[" + @levels.join(",") + "]"
    end

    Zero = new([0.0] * StrengthLevels)
  end
end
