# Copyright (C) 2012 by Tim Felgentreff

module Cassowary
  class AbstractVariable
    attr_accessor :name

    def initialize(hash = {})
      self.name = hash[:name]
    end

    def dummy?
      false
    end

    def external?
      raise NotImplementedError, "my subclass should have implemented #external?"
    end

    def pivotable?
      raise NotImplementedError, "my subclass should have implemented #pivotable?"
    end

    def restricted?
      raise NotImplementedError, "my subclass should have implemented #restricted?"
    end

    def inspect
      if name
        "#{name}"
      else
        "<CV#0x#{object_id.to_s(16)}>"
      end
    end
  end
end
