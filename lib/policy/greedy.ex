defmodule Policy.Greedy do
end

defimpl Policy, for: Policy.Greedy do
  def choose(greedy, []), do: nil
  def choose(random, action_values) do
    action_values
    |> Enum.max_by(fn {_action, value} -> value end)
    |> elem(0)
  end
end
