defmodule Memory.StateServerTest do
  use ExUnit.Case, async: false
  doctest Excov
  alias Memory.StateServer

  setup _context do
    {:ok, pid} = StateServer.start_link()
    state1 = {true, :hold, "low"}
    valid_actions =  ~w[buy sell]a
    seed = 0.0

    StateServer.create_or_update(pid, {state1, :buy, 1.234}, {valid_actions, seed})
    %{pid: pid, state: state1, seed: seed, valid_actions: valid_actions}
  end

  test "persists actions", %{pid: pid, state: state, seed: seed, valid_actions: valid_actions} do
    actions = %{buy: 1.234, sell: 0.0}
    assert StateServer.lookup(pid, state) === actions

    actions = %{buy: 1.234, sell: 3.234}
    assert StateServer.create_or_update(pid, {state, :sell, 3.234}, {valid_actions, seed}) === :ok
    assert StateServer.lookup(pid, state) === actions

    actions = %{buy: 0.7, sell: 3.234}
    assert StateServer.create_or_update(pid, {state, :buy, 0.7}, {valid_actions, seed}) === :ok
    assert StateServer.lookup(pid, state) === actions
  end
end


