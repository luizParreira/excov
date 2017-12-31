defmodule Excov do
  @moduledoc """
  Documentation for Excov.
  """

  @doc """
  Starts `n` training trials concurrently and returns the game reset

  ## Examples
      iex> game = %Excov.DummyMarket{}
      iex> play_policy = %Policy.Egreedy{epsilon: 0.6}
      iex> train_policy = %Policy.Greedy{}
      iex> brain = %Brain{alpha: 1.0, gamma: 0.0}
      iex> {:ok, pid} = Memory.Server.start_link()
      iex> memory = %Memory.Table{pid: pid, seed: 0.0}
      iex> Excov.train(2, {game, play_policy, train_policy, memory, brain})
      [ok: :ok, ok: :ok]
  """
  def train(trials, state) do
    Play.train(trials, state)
  end

  @doc """
  Tests `n` times

  ## Examples
      iex> game = %Excov.DummyMarket{}
      iex> play_policy = %Policy.Egreedy{epsilon: 0.6}
      iex> train_policy = %Policy.Greedy{}
      iex> brain = %Brain{alpha: 1.0, gamma: 0.0}
      iex> {:ok, pid} = Memory.Server.start_link()
      iex> memory = %Memory.Table{pid: pid, seed: 0.0}
      iex> Excov.train(2, {game, play_policy, train_policy, memory, brain})
      iex> Excov.test(1, {game, train_policy, memory})
      [ok: %Excov.DummyMarket{base_pair: 0.0, initial_value: 1.0,
             last_value: 1.0, price: 2.3, prices: [1.0, 2.3], step: 1,
             trading_pair: 1.0}]
  """
  def test(trials, state) do
    Play.test(trials, state)
  end
end
