defmodule Play do
  def train(n, state) do
    0..n
    |> Task.async_stream(Train, :train, [state])
    |> Enum.to_list
  end
end
