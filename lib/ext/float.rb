# Copyright (C) 2012 by Tim Felgentreff

class Float
  def cl_approx(float)
    # Answer true if I am approximately equal to the argument
    epsilon = Cassowary::SimplexSolver::Epsilon
    if self == 0.0
      float.abs < epsilon
    elsif float == 0.0
      abs < epsilon
    else
      (self - float).abs < (abs * epsilon)
    end
  end

  def cl_approx_zero
    cl_approx 0.0
  end

  def definitely_negative
    # return true if I am definitely negative (i.e. smaller than negative epsilon)"
    self < (0.0 - Cassowary::SimplexSolver::Epsilon)
  end
end
