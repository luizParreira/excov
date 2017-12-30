defmodule Memory.StateServer do
  use GenServer

  ## Client API

  @doc """
  Starts the state server.
  => {:ok, pid}
  """
  def start_link() do
    # 1. Pass the name to GenServer's init
    GenServer.start_link(__MODULE__, %{})
  end

  @doc """
  Creates or updates the state represented by given action and value
  also receives valid actions and seed

  # TODO: Remove `valid_actions` from here
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
