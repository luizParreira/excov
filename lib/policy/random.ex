defmodule Policy.Random do
  defstruct []
end

defimpl Policy, for: Policy.Random do
  def choose(_random, []), do: nil

  def choose(_random, action_values) do
    action_values
    |> Enum.random()
    |> elem(0)
  end
end
