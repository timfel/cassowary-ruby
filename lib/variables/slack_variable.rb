# Copyright (C) 2012 by Tim Felgentreff

module Cassowary
  class SlackVariable < AbstractVariable
    def external?
      false
    end

    def pivotable?
      true
    end

    def restricted?
      true
    end
  end
end
