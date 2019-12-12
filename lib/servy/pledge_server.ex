defmodule Servy.PledgeServer do
  @process_name :pledge_server

  use GenServer

  defmodule State do
    defstruct cache_size: 3, pledges: []
  end

  # Client Interface

  def start do
    GenServer.start(__MODULE__, %State{}, name: @process_name)
  end

  def create_pledge(name, amount) do
    GenServer.call(@process_name, {:create_pledge, name, amount})
  end

  def recent_pledges do
    GenServer.call(@process_name, :recent_pledges)
  end

  def total_pledged do
    GenServer.call(@process_name, :total_pledged)
  end

  def clear do
    GenServer.cast(@process_name, :clear)
  end

  def set_cache_size(size) do
    GenServer.cast(@process_name, {:set_cache_size, size})
  end

  # Server callbacks

  def init(state) do
    pledges = fetch_recent_pledges_from_service()
    new_state = %{state | pledges: pledges}
    {:ok, new_state}
  end

  def handle_cast(:clear, state) do
    {:noreply, %{state | pledges: []}}
  end

  def handle_cast({:set_cache_size, size}, state) do
    {:noreply, %{state | cache_size: size}}
  end

  def handle_call(:total_pledged, _from, state) do
    total = Enum.map(state.pledges, &elem(&1, 1)) |> Enum.sum()
    {:reply, total, state}
  end

  def handle_call(:recent_pledges, _from, state) do
    {:reply, state.pledges, state}
  end

  def handle_call({:create_pledge, name, amount}, _from, state) do
    {:ok, id} = send_pledge_to_service(name, amount)
    most_recent_pledges = Enum.take(state.pledges, state.cache_size - 1)
    cached_pledges = [{name, amount} | most_recent_pledges]
    new_state = %{state | pledges: cached_pledges}
    {:reply, id, new_state}
  end

  def handle_info(message, state) do
    IO.puts("Can't touch this! #{inspect(message)}")
    {:noreply, state}
  end

  defp send_pledge_to_service(_name, _amount) do
    # code to send to pledge service

    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end

  defp fetch_recent_pledges_from_service do
    # Gets data

    # Example data
    [{"wilma", 15}, {"fred", 25}]
  end
end

# alias Servy.PledgeServer

# {:ok, pid} = PledgeServer.start()

# send(pid, {:stop, "hammertime"})

# PledgeServer.set_cache_size(4)

# IO.inspect(PledgeServer.create_pledge("larry", 10))
# IO.inspect(PledgeServer.create_pledge("Mo", 20))
# IO.inspect(PledgeServer.create_pledge("curly", 30))
# IO.inspect(PledgeServer.create_pledge("daisy", 40))

# PledgeServer.clear()

# IO.inspect(PledgeServer.create_pledge("grace", 50))

# IO.inspect(PledgeServer.recent_pledges())

# IO.inspect(PledgeServer.total_pledged())

# IO.inspect(Process.info(pid, :messages))
