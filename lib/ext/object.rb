# Copyright (C) 2012 by Tim Felgentreff

class Object
  def cl_approx(x)
    self == x
  end

  def symbolic_weight?
    false
  end
end
