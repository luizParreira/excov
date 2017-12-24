defmodule Policy.EgreedyTest do
  use ExUnit.Case, async: true
  alias Policy.Egreedy

  test "choose when random policy chosen" do
    action_values = [{:buy, 1.23}, {:sell, 2.32}, {:sell_margin, 1.23}, {:buy_margin, 1.34}]
    random_value = 0.5
    egreedy = %Egreedy{action_values: action_values, epsilon: 0.6, random_value: random_value}
    egreedy_choose = Policy.choose(egreedy)
    assert Enum.any?(action_values, fn {action, _value} ->  egreedy_choose == action end)
  end

  test "choose when greedy policy chosen" do
    action_values = [{:buy, 1.23}, {:sell, 2.32}, {:sell_margin, 1.23}, {:buy_margin, 1.34}]
    random_value = 0.7
    egreedy = %Egreedy{action_values: action_values, epsilon: 0.6, random_value: random_value}
    egreedy_choose = Policy.choose(egreedy)
    assert egreedy_choose === :sell
  end


  test "choose when empty list" do
    greedy = %Egreedy{action_values: []}
    assert Policy.choose(greedy) === nil
  end
end


