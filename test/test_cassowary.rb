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

    cxy2 = (x * 1.as_linear_expression).cn_equal(1000)
    solver.add_constraint cxy2
    assert x.value.cl_approx 1000
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

  def test_auto_solve_off
    x = Variable.new name: 'x'
    y = Variable.new name: 'y'
    solver = SimplexSolver.new
    solver.auto_solve = false
    solver.add_constraint x.cn_equal(1.0, Strength::WeakStrength)
    solver.add_constraint y.cn_equal(5.0, Strength::StrongStrength)
    solver.solve
    assert x.value.cl_approx(1.0)
    assert y.value.cl_approx(5.0)
    solver.add_constraint ((x*2).cn_equal y)
    # the y=x*2 shouldn't be satisfied yet
    assert x.value.cl_approx(1.0)
    assert y.value.cl_approx(5.0)
    solver.solve
    # now it should be
    assert x.value.cl_approx(2.5)
    assert y.value.cl_approx(5.0)
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

  def test_edit1var
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

  def test_edit2vars
    x = Variable.new name: 'x', value: 20
    y = Variable.new name: 'y', value: 30
    z = Variable.new name: 'z', value: 120

    solver = SimplexSolver.new
    solver.add_stay x, Strength::WeakStrength
    solver.add_stay z, Strength::WeakStrength
    solver.add_constraint z.cn_equal x*2 + y
    assert x.value.cl_approx 20
    assert y.value.cl_approx 80
    assert z.value.cl_approx 120

    solver.add_edit_var x, Strength::StrongStrength
    solver.add_edit_var y, Strength::StrongStrength
    solver.begin_edit
    solver.suggest_value x, 10
    solver.suggest_value y, 5
    solver.resolve
    assert x.value.cl_approx 10
    assert y.value.cl_approx 5
    assert z.value.cl_approx 25

    solver.suggest_value x, -10
    solver.suggest_value y, 15
    solver.resolve
    assert x.value.cl_approx -10
    assert y.value.cl_approx 15
    assert z.value.cl_approx -5
    solver.end_edit
  end

  def test_edit2vars_no_auto_solve
    # same as test_edit2vars, except that auto_solve is set to false
    # for the solver
    x = Variable.new name: 'x', value: 20
    y = Variable.new name: 'y', value: 30
    z = Variable.new name: 'z', value: 120

    solver = SimplexSolver.new
    solver.auto_solve = false
    solver.add_stay x, Strength::WeakStrength
    solver.add_stay z, Strength::WeakStrength
    solver.add_constraint z.cn_equal x*2 + y
    # note that we need to call solve explicitly for the
    # variables to be solved for
    solver.solve  
    assert x.value.cl_approx 20
    assert y.value.cl_approx 80
    assert z.value.cl_approx 120

    solver.add_edit_var x, Strength::StrongStrength
    solver.add_edit_var y, Strength::StrongStrength
    solver.solve
    solver.begin_edit
    solver.suggest_value x, 10
    solver.suggest_value y, 5
    solver.resolve
    assert x.value.cl_approx 10
    assert y.value.cl_approx 5
    assert z.value.cl_approx 25

    solver.suggest_value x, -10
    solver.suggest_value y, 15
    solver.resolve
    assert x.value.cl_approx -10
    assert y.value.cl_approx 15
    assert z.value.cl_approx -5
    solver.end_edit
  end


end
