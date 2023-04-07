defmodule Pkm.Router do
  @moduledoc """
  Central module for routing
  """
  use Plug.Router
  alias Pkm.Message
  alias Pkm.Store, as: KeyStore
  import Plug.Conn

  if Mix.env() == :dev do
    plug(Plug.Logger)
  end

  plug(:match)
  plug(:dispatch)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)

  get "/" do
    :telemetry.execute([:router, :http], %{type: "hit"}, %{where: "index"})

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(%Message{message: "Hello, World!"}))
  end

  get "/keys" do
    :telemetry.execute([:router, :http], %{type: "hit"}, %{where: "keys"})

    conn =
      conn
      |> fetch_query_params()

    %{"key" => key} = conn.query_params

    case KeyStore.get(key) do
      nil ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(404, Jason.encode!(%Message{message: "Queried Key doesn't exist"}))

      _ ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Jason.encode!(%Message{message: "Queried Key exists"}))
    end
  end

  get "/ws" do
    conn
    |> WebSockAdapter.upgrade(Pkm.HTTP.WebSocket, [], timeout: 60_000)
    |> halt()
  end

  match _ do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(404, Jason.encode!(%Message{message: "not_found"}))
  end
end
