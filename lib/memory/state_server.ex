defmodule Memory.StateServer do
  use GenServer

  ## Client API

  @doc """
  Starts the registry with the given options.

  `:name` is always required.
  """
  def start_link() do
    # 1. Pass the name to GenServer's init
    GenServer.start_link(__MODULE__, %{})
  end

  @doc """
  Ensures there is a bucket associated with the given `name` in `server`.
  """
  def create_or_update(pid, {state, action, value}, {valid_actions, seed}) do
    GenServer.cast(pid, {:create_or_update, state, action, value, valid_actions, seed})
  end

  def view(pid) do
    GenServer.call(pid, :view)
  end

  def stop(pid) do
    GenServer.stop(pid)
  end

  def lookup(server, state) do
    GenServer.call(server, {:lookup, state})
  end

  # 4. The previous handle_call callback for lookup was removed

  def handle_cast({:create_or_update, state, action, value, valid_actions, seed}, all_state) do
    case Map.get(all_state, state) do
      nil ->
        actions = valid_actions |> Enum.map(&({&1, seed})) |> Map.new |> Map.put(action, value)
        {:noreply, Map.put(all_state, state, actions)}
      actions ->
        {:noreply, %{all_state | state => %{actions | action => value}}}
    end
  end

  def handle_call({:lookup, state}, _from, all_state) do
    {:reply, Map.get(all_state, state), all_state}
  end

  def handle_call(:view, _from, state) do
    {:reply, state, state}
  end

  def terminate(_reason, state) do
    IO.puts "Stoping server ..."
    IO.inspect state
    :ok
  end
end
