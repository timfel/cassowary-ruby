# Copyright (C) 2012 by Tim Felgentreff

module Cassowary
  class Strength
    attr_accessor :name, :symbolic_weight

    def initialize(name = nil, symbolic_weight = nil)
      self.name = name
      self.symbolic_weight = symbolic_weight
    end

    def required?
      self == RequiredStrength
    end

    def inspect
      "#{name}"
    end

    def each
      [RequiredStrength, StrongStrength, MediumStrength, WeakStrength].each do |str|
        yield str
      end
    end

    RequiredStrength = new "required"
    StrongStrength = new "strong", SymbolicWeight.new([1.0])
    MediumStrength = new "medium", SymbolicWeight.new([0.0, 1.0])
    WeakStrength = new "weak", SymbolicWeight.new([0.0, 0.0, 1.0])
  end
end
