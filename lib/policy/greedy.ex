defmodule Policy.Greedy do
  defstruct []
end

defimpl Policy, for: Policy.Greedy do
  def choose(_greedy, []), do: nil
  def choose(_random, action_values) do
    action_values
    |> Enum.max_by(fn {_action, value} -> value end)
    |> elem(0)
  end
end
