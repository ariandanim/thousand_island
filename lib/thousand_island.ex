defmodule ThousandIsland do
  alias ThousandIsland.{Listener, Server, ServerConfig}

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :supervisor,
      restart: :permanent,
      shutdown: 5000
    }
  end

  def start_link(opts \\ []) do
    opts
    |> ServerConfig.new()
    |> Server.start_link()
  end

  def local_port(pid) do
    pid |> Server.listener_pid() |> Listener.listener_port()
  end

  def stop(pid, connection_wait \\ 15000) do
    # This will shut down the listener and all acceptors
    # We do this before shutting down the supervision tree so
    # that we stop accepting new connections while doing so
    pid |> Server.listener_pid() |> Listener.stop()

    Supervisor.stop(pid, :normal, connection_wait)
  end
end
