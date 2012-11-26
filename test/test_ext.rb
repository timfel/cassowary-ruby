require File.expand_path("../test_helper", __FILE__)

class ExtTests < Test::Unit::TestCase
  def test_float_approx_zero
    assert !1.1.cl_approx_zero
    assert 0.0.cl_approx_zero
    assert 0.1e-8.cl_approx_zero
  end

  def test_float_approx
    assert 1.1.cl_approx 1.1
  end

  def test_float_negative
    assert -1.1.definitely_negative
    assert -0.1e-5.definitely_negative
    assert ! -0.1e-8.definitely_negative
  end

  def test_numeric_as_linear_expression
    expr = 1.as_linear_expression
    assert expr.terms.empty?
    assert expr.constant == 1.to_f

    expr = 1.1.as_linear_expression
    assert expr.terms.empty?
    assert expr.constant == 1.1
  end

  def test_object_approx
    assert "foo".cl_approx "foo"
    assert ! Object.new.cl_approx(Object.new)
  end

  def test_object_symbolic_weight
    assert !Object.new.symbolic_weight?
  end
end
