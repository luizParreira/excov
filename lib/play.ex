defmodule Play do
  def train(n, _state) when n < 1, do: nil

  def train(n, state) do
    0..(n - 1)
    |> Task.async_stream(Train, :train, [state])
    |> Enum.to_list()
  end

  def test(n, _state) when n < 1, do: nil

  def test(n, state) do
    0..(n - 1)
    |> Task.async_stream(Test, :test, [state])
    |> Enum.to_list()
  end
end
