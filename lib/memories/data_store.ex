defmodule Memories.DataStore do
  use GenServer

  ## Client API

  @doc """
  Starts the registry with the given options.

  `:name` is always required.
  """
  def start_link(opts) do
    # 1. Pass the name to GenServer's init
    server = Keyword.fetch!(opts, :name)
    GenServer.start_link(__MODULE__, server, opts)
  end

  @doc """
  Ensures there is a bucket associated with the given `name` in `server`.
  """
  def create_or_update(server, {state, action, value}, valid_actions) do
    GenServer.call(server, {:create_or_update, state, action, value, valid_actions})
  end

  def lookup(server, state) do
    case :ets.lookup(server, state) do
      [{^state, actions}] -> {:ok, actions}
      [] -> :error
    end
  end

  ## Server callbacks

  def init(table) do
    # 3. We have replaced the names map by the ETS table
    names = :ets.new(table, [:named_table, read_concurrency: true])
    {:ok, names}
  end

  # 4. The previous handle_call callback for lookup was removed

  def handle_call({:create_or_update, state, action, value, valid_actions}, _from, table_name) do
    case lookup(table_name, state) do
      {:ok, actions} ->
        actions = %{actions | action => value}
        :ets.insert(table_name, {state, actions})
        {:reply, :ok, table_name}
      :error ->
        actions = valid_actions |> Enum.map(&({&1, 0.0})) |> Map.new |> Map.put(action, value)
        :ets.insert(table_name, {state, actions})
        {:reply, :ok, table_name}
    end
  end

  def handle_info({:DOWN, _ref, :process, _pid, _reason}, {table_name, _state, _actions}) do
    # 6. Delete from the ETS table instead of the map
    :ets.delete(table_name)
    {:noreply, table_name}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end
end
