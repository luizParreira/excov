defmodule Policy.Greedy do
  defstruct []
end

defimpl Policy, for: Policy.Greedy do
  def choose(_greedy, []), do: nil
  def choose(_greedy, action_values) do
    action_values
    |> Enum.max_by(& elem(&1, 1))
    |> elem(0)
  end
end
