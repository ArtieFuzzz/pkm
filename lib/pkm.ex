defmodule Pkm do
  @moduledoc false
  alias Pkm.Router
  alias Pkm.Store
  require Logger
  use Application

  def start(_type, _args) do
    Logger.info("Booting up...")
    children = [{Bandit, plug: Router, scheme: :http, options: [port: 3000]}, Store]

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
