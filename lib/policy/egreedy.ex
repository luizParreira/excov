defmodule Policy.Egreedy do
  defstruct [:epsilon]
end

defimpl Policy, for: Policy.Egreedy do
  alias Policy.Egreedy

  def choose(_egreedy, []), do: nil
  def choose(policy, action_values) do
    choose_policy(policy, :rand.uniform, action_values)
  end

  defp choose_policy(%Egreedy{epsilon: e}, value, action_values ) when value < e do
    Policy.choose(%Policy.Random{}, action_values)
  end

  defp choose_policy(_egreedy, _value, action_values) do
    Policy.choose(%Policy.Greedy{}, action_values)
  end
end
