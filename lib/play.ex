defmodule Play do
  def train(n, state) when n < 1, do: nil
  def train(n, state) do
    0..n
    |> Task.async_stream(Train, :train, [state])
    |> Enum.to_list
  end
end
