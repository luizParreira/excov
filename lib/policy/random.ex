defmodule Policy.Random do
end

defimpl Policy, for: Policy.Random do
  def choose(random, []), do: nil
  def choose(random, action_values) do
    action_values
    |> Enum.random
    |> elem(0)
  end
end
