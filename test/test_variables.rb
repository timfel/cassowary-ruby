require File.expand_path("../test_helper", __FILE__)

class VariablesTests < Test::Unit::TestCase
  def test_operations
    x = Cassowary::Variable.new name: 'x', value: 20
    expr = x / 10
    assert expr.constant == 0
    assert expr.terms[x] == 0.1

    expr = x * 10
    assert expr.terms[x] == 10

    expr = x - 10
    assert expr.constant == -10

    expr = x + 10
    assert expr.constant == 10

    expr = -x
    assert expr.terms[x] == -1
  end

  def test_inspect
    x = Cassowary::Variable.new name: 'x', value: 21.1
    assert_equal "x[21.1]", x.inspect

    x = Cassowary::Variable.new name: 'x'
    assert_equal "x[nil]", x.inspect

    x = Cassowary::SlackVariable.new
    assert_equal "<CV#0x" + x.object_id.to_s(16) + ">", x.inspect
  end

  def test_evaluating_linear_expressions
    x = Cassowary::Variable.new name: 'x', value: 20
    expr = x / 10
    assert expr.value == 2

    expr *= 2
    assert expr.value == 4

    expr += 10
    assert expr.value == 14

    expr -= 3
    assert expr.value == 11
  end
end
