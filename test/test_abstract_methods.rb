require File.expand_path("../test_helper", __FILE__)

class AbstractMethodsTest < Test::Unit::TestCase
  def test_constraint
    assert_raise NotImplementedError do
      Cassowary::Constraint.new.expression
    end
  end

  def test_abstract_variable
    var = Cassowary::AbstractVariable.new
    assert_raise NotImplementedError do
      var.external?
    end
    assert_raise NotImplementedError do
      var.pivotable?
    end
    assert_raise NotImplementedError do
      var.restricted?
    end
  end
end
