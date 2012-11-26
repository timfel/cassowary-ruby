# Copyright (C) 2012 by Tim Felgentreff

module Cassowary
  class ObjectiveVariable < AbstractVariable
    def external?
      false
    end

    def pivotable?
      false
    end

    def restricted?
      false
    end
  end
end
