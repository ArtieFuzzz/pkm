defmodule Pkm.HTTP.WebSocket do
  @moduledoc false
  require Logger

  def init(_args) do
    {:ok, []}
  end

  #def handle_in({"ping", [opcode: :text]}, state) do
  #  {:reply, :ok, {:text, "pong"}, state}
  #end

  #def handle_in({text, [opcode: :text]}, state) do
  #  {:reply, :ok, {:text, text}, state}
  #end

  def handle_in({payload, [opcode: :text]}, state) do
    case Jason.decode(payload) do
      {:ok, data} -> op(data["op"], data, state)
      {:error, _} -> {:reply, :ok, {:text, "PAYLOAD_INVALID"}, state}
    end
  end

  def op(0, data, state) do
    payload = Jason.encode!(data)
    {:reply, :ok, {:text, "You made it!\nOriginal Payload: #{payload}"}, state}
  end

  def terminate(:timeout, state) do
    {:ok, state}
  end

  def terminate(:error, state) do
    Logger.warn("An Error ocurred...")
    {:ok, state}
  end
end
