defmodule Memories.TableTest do
  use ExUnit.Case, async: false
  @valid_actions ~w[buy sell]a

  alias Memories.{Table, DataStore}
  setup context do
    table = %Table{name: context.test, seed: 1.3}
    {:ok, _pid} = Table.init(table)
    state = {true, :hold, "low"}

    DataStore.create_or_update(table.name, {state, :buy, 1.234}, {@valid_actions, table.seed})
    %{table: table, state: state}
  end

  test "get", %{table: table, state: state} do
    assert Memory.get(table, state, :buy) === 1.234

    DataStore.create_or_update(table.name, {state, :sell, 3.234}, {@valid_actions, table.seed})
    assert Memory.get(table, state, :sell) === 3.234

    DataStore.create_or_update(table.name, {state, :buy, 0.7}, {@valid_actions, table.seed})
    assert Memory.get(table, state, :buy) === 0.7
  end

  test "set", %{table: table, state: state} do
    Memory.set(table, state, :buy, 1.23, @valid_actions)

    assert Memory.get(table, state, :buy) === 1.23
    assert Memory.get(table, state, :sell) === 1.3

    state1 = {false, :no_hold, "high"}
    Memory.set(table, state1, :sell, 1.34, @valid_actions)

    assert Memory.get(table, state1, :sell) === 1.34
    assert Memory.get(table, state1, :buy) === 1.3

    Memory.set(table, state1, :buy, 0.34, @valid_actions)

    assert Memory.get(table, state1, :sell) === 1.34
    assert Memory.get(table, state1, :buy) === 0.34
  end

  test "get when no value saved for state", %{table: table, state: _state} do
    assert Memory.get(table, {false, :unknown, "unknwon"}, :sell) === table.seed
  end
end


