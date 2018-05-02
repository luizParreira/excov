defmodule Policy.GreedyTest do
  use ExUnit.Case, async: true
  alias Policy.Greedy

  test "choose" do
    action_values = [{:buy, 1.23}, {:sell, 2.32}, {:sell_margin, 1.23}, {:buy_margin, 1.34}]
    greedy_choose = Policy.choose(%Greedy{}, action_values)
    assert greedy_choose === :sell
  end

  test "choose when empty list" do
    assert Policy.choose(%Greedy{}, []) === nil
  end
end
