require File.expand_path("../test_helper", __FILE__)

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

  def test_add_delete2
    x = Variable.new name: 'x'
    y = Variable.new name: 'y'

    solver = SimplexSolver.new
    solver.add_constraint x.cn_equal(100.0, Strength::WeakStrength)
    solver.add_constraint y.cn_equal(120.0, Strength::StrongStrength)

    c10 = x.cn_leq(10.0)
    c20 = x.cn_leq(20.0)
    solver.add_constraint c10
    solver.add_constraint c20
    assert x.value.cl_approx(10.0)
    assert y.value.cl_approx(120.0)

    solver.remove_constraint c10
    assert x.value.cl_approx 20.0
    assert y.value.cl_approx 120.0

    cxy = (x * 2).cn_equal y
    solver.add_constraint cxy
    assert x.value.cl_approx 20
    assert y.value.cl_approx 40

    solver.remove_constraint c20
    assert x.value.cl_approx 60
    assert y.value.cl_approx 120

    solver.remove_constraint cxy
    assert x.value.cl_approx 100
    assert y.value.cl_approx 120
  end

  def test_add_delete3
    x = Variable.new name: 'x'
    solver = SimplexSolver.new
    c1 = x.cn_equal 100, Strength::WeakStrength, 5
    c2 = x.cn_equal 200, Strength::WeakStrength

    solver.add_constraint c1
    solver.add_constraint c2
    assert x.value.cl_approx 100

    solver.remove_constraint c1
    assert x.value.cl_approx 200
  end

  def test_inconsistent1
    x = Variable.new name: 'x'
    solver = SimplexSolver.new
    solver.add_constraint x.cn_equal 10
    assert_raise RequiredFailure do
      solver.add_constraint x.cn_equal 5
    end
  end

  def test_inconsistent2
    x = Variable.new name: 'x'
    solver = SimplexSolver.new
    solver.add_constraint x.cn_geq 10
    assert_raise RequiredFailure do
      solver.add_constraint x.cn_leq 5
    end
  end

  def test_stay1
    x = Variable.new name: 'x', value: 20
    solver = SimplexSolver.new

    solver.add_stay x, Strength::WeakStrength
    assert x.value.cl_approx 20
  end

  def test_two_solutions
    x = Variable.new name: 'x'
    y = Variable.new name: 'y'

    solver = SimplexSolver.new
    solver.add_constraint x.cn_leq y
    solver.add_constraint y.cn_equal x + 3
    solver.add_constraint x.cn_equal 10, Strength::WeakStrength
    solver.add_constraint y.cn_equal 10, Strength::WeakStrength

    assert(x.value.cl_approx(10) && y.value.cl_approx(13) ||
           x.value.cl_approx(7) && y.value.cl_approx(10))
  end

  def test_weighted1
    x = Variable.new name: 'x'
    solver = SimplexSolver.new

    c15 = x.cn_equal 15, Strength::WeakStrength
    c20 = x.cn_equal 20, Strength::WeakStrength, 2

    solver.add_constraint c15
    assert x.value.cl_approx 15

    solver.add_constraint c20
    assert x.value.cl_approx 20

    solver.remove_constraint c20
    assert x.value.cl_approx 15
  end

  def test_edit1
    x = Variable.new name: 'x', value: 20
    y = Variable.new name: 'y', value: 30

    solver = SimplexSolver.new
    solver.add_stay x, Strength::WeakStrength
    solver.add_constraint x.cn_geq 10
    solver.add_constraint x.cn_leq 100
    solver.add_constraint x.cn_equal y * 2
    assert x.value.cl_approx 20
    assert y.value.cl_approx 10

    solver.add_edit_var y, Strength::StrongStrength
    solver.begin_edit
    solver.suggest_value y, 35
    solver.resolve
    assert x.value.cl_approx 70
    assert y.value.cl_approx 35

    solver.suggest_value y, 80
    solver.resolve
    assert x.value.cl_approx 100
    assert y.value.cl_approx 50

    solver.suggest_value y, 25
    solver.resolve
    assert x.value.cl_approx 50
    assert y.value.cl_approx 25

    solver.end_edit
    assert x.value.cl_approx 50
    assert y.value.cl_approx 25

    solver.add_edit_var x, Strength::StrongStrength
    solver.begin_edit
    solver.suggest_value x, 44.0
    solver.resolve
    assert x.value.cl_approx 44
    assert y.value.cl_approx 22

    solver.end_edit
  end
end
