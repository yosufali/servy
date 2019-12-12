defmodule Servy.KickStarter do
  use GenServer

  def start do
    IO.puts("Starting the Kickstarter...")
    GenServer.start(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    Process.flag(:trap_exit, true)
    server_pid = start_server()
    {:ok, server_pid}
  end

  def handle_info({:EXIT, _pid, reason}, _state) do
    IO.puts("HTTP Server exited: #{inspect(reason)}")
    server_pid = start_server()
    {:noreply, server_pid}
  end

  def start_server do
    IO.puts("Starting the HTTP Server")

    server_pid = spawn_link(Servy.HttpServer, :start, [4000])
    Process.register(server_pid, :http_server)
    server_pid
  end
end