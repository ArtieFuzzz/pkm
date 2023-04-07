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
    Logger.debug("")
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

  def init(state) do
    {:ok, state}
  end

  def handle_call({:inc, state}) do
    {:ok, state ++ 1}
  end

  def handle_call({:now, state}) do
    {:ok, state}
  end

  def inc() do
    GenServer.call(__MODULE__, :inc)
  end

  def now() do
    {:ok, state} = GenServer.call(__MODULE__, :now)

    state
  end
end
