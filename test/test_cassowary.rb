$LOAD_PATH.unshift("../../lib", __FILE__)

require "test/unit"
require "cassowary"

class CassowaryTests < Test::Unit::TestCase
  include Cassowary

  def test_add_delete1
    x = Variable.new(name: 'x')
    solver = SimplexSolver.new
    solver.add_constraint x.cn_equal(100.0, Strength::WeakStrength)
    c10 = x.cn_leq 10.0
    c20 = x.cn_leq 20.0
    solver.add_constraint c10
    solver.add_constraint c20
    assert x.value.cl_approx(10.0)

    solver.remove_constraint c10
    assert x.value.cl_approx(20.0)

    solver.remove_constraint c20
    assert x.value.cl_approx(100.0)

    c10again = x.cn_leq 10.0
    solver.add_constraint c10
    solver.add_constraint c10again
    assert x.value.cl_approx(10.0)

    solver.remove_constraint c10
    assert x.value.cl_approx(10.0)

    solver.remove_constraint c10again
    assert x.value.cl_approx(100.0)
  end
end
