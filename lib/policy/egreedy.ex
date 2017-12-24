defmodule Policy.Egreedy do
  defstruct [:random_value, :epsilon]
end

defimpl Policy, for: Policy.Egreedy do
  alias Policy.Egreedy

  def choose(egreedy, []), do: nil
  def choose(%Egreedy{epsilon: e, random_value: value}, action_values) when value < e do
    Policy.choose(Policy.Random, action_values)
  end
  def choose(egreedy, action_values) do
    Policy.choose(Policy.Greedy, action_values)
  end
end
