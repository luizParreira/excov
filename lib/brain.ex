defmodule Brain do
  defstruct [:alpha, :gamma]

  def learn(brain, current_value, next_value, reward) do
    current_value + brain.alpha * (reward + brain.gamma * next_value - current_value)
  end
end
