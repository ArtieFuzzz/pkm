defmodule Pkm do
  @moduledoc false
  alias Pkm.Router
  alias Pkm.Store
  alias Pkm.Metrics.Counter, as: MetricsCounter
  require Logger
  use Application

  def start(_type, _args) do
    Logger.info("Booting up...")
    :ok = Pkm.Metrics.Router.setup()
    children = [MetricsCounter, Store, {Bandit, plug: Router, scheme: :http, options: [port: 3000]}]

    Supervisor.start_link(children, strategy: :one_for_one, name: Pkm.Supervisor)
  end
end

defmodule Pkm.Message do
  @moduledoc """
  Struct for JSON messages
  """
  @derive Jason.Encoder
  defstruct [:message]
end
