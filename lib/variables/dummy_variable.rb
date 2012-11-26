# Copyright (C) 2012 by Tim Felgentreff

module Cassowary
  class DummyVariable < AbstractVariable
    def dummy?
      true
    end

    def external?
      false
    end

    def pivotable?
      false
    end

    def restricted?
      true
    end
  end
end
