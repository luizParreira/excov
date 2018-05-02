defmodule Policy.EgreedyTest do
  use ExUnit.Case, async: true
  alias Policy.Egreedy

  test "choose correct policy based on random value set by seed" do
    :rand.seed(:exsplus, {10, 10, 10})
    action_values = [{:buy, 1.23}, {:sell, 2.32}, {:sell_margin, 1.23}, {:buy_margin, 1.34}]
    egreedy = %Egreedy{epsilon: 0.6}
    egreedy_choose = Policy.choose(egreedy, action_values)
    assert Enum.any?(action_values, fn {action, _value} -> egreedy_choose == action end)

    egreedy = %Egreedy{epsilon: 0.6}
    egreedy_choose = Policy.choose(egreedy, action_values)
    assert egreedy_choose === :sell
  end

  test "choose when empty list" do
    greedy = %Egreedy{epsilon: 0.6}
    assert Policy.choose(greedy, []) === nil
  end
end
