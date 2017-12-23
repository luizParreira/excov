defmodule Memories.DataStoreTest do
  use ExUnit.Case, async: false
  doctest Excov
  @valid_actions ~w[buy sell]a


  alias Memories.DataStore
  setup context do
    {:ok, _pid} = start_supervised({Memories.DataStore, name: context.test})
    state1 = {true, :hold, "low"}

    DataStore.create_or_update(context.test, {state1, :buy, 1.234}, @valid_actions)
    %{name: context.test, state: state1}
  end

  test "persists actions", %{name: name, state: state} do
    valid_actions =  ~w[buy sell]a

    actions = %{buy: 1.234, sell: 0.0}
    assert {:ok, actions} == DataStore.lookup(name, state)

    actions = %{buy: 1.234, sell: 3.234}
    DataStore.create_or_update(name, {state, :sell, 3.234}, valid_actions)
    assert {:ok, actions} == DataStore.lookup(name, state)

    actions = %{buy: 0.7, sell: 3.234}
    DataStore.create_or_update(name, {state, :buy, 0.7}, valid_actions)
    assert {:ok, actions} == DataStore.lookup(name, state)
  end
end


