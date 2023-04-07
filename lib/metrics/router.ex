defmodule Pkm.Metrics.Router do
  @moduledoc false
  require Logger
  alias Pkm.Metrics.Counter


  def setup do
    events = [:router, :http]

    :ok = :telemetry.attach("telemetry-routing", events, &__MODULE__.handle_event/4, nil)
  end

  def handle_event([:router, :http], %{type: "hit"}, _route, _config) do
    Counter.inc()
    current = Counter.now()
    Logger.debug("Counted > #{current}")
  end
end

defmodule Pkm.Metrics.Counter do
  @moduledoc """
  This counter is responsible for keeping track of how many times any route has been hit.
  """
  use GenServer

  def start_link(_args) do
    GenServer.start_link(__MODULE__, 0, name: __MODULE__)
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_cast(:inc, state) do
    {:noreply, state + 1}
  end

  @impl true
  def handle_call(:now, _from, state) do
    {:reply, state, state}
  end

  def inc() do
    GenServer.cast(__MODULE__, :inc)
  end

  def now() do
    GenServer.call(__MODULE__, :now)
  end
end
