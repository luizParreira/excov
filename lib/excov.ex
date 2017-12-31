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
      iex> {:ok, pid} = Memory.StateServer.start_link()
      iex> memory = %Memory.Table{pid: pid, seed: 0.0}
      iex> Excov.play(2, {game, play_policy, train_policy, memory, brain})
      [ok: :ok, ok: :ok, ok: :ok]
  """
  def play(trials, state) do
    Play.train(trials, state)
  end

  @doc """
  Tests `n` times

  ## Examples
      iex> game = %Excov.DummyMarket{}
      iex> play_policy = %Policy.Egreedy{epsilon: 0.6}
      iex> train_policy = %Policy.Greedy{}
      iex> brain = %Brain{alpha: 1.0, gamma: 0.0}
      iex> {:ok, pid} = Memory.StateServer.start_link()
      iex> memory = %Memory.Table{pid: pid, seed: 0.0}
      iex> Excov.play(2, {game, play_policy, train_policy, memory, brain})
      [ok: :ok, ok: :ok, ok: :ok]
  """
  def test(trials, state) do
    Play.test(trials, state)
  end
end
