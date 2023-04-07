defmodule Pkm.HTTP.WebSocket do
  @moduledoc false
  require Logger

  def init(_args) do
    {:ok, []}
  end

  def handle_in({"ping", [opcode: :text]}, state) do
    {:reply, :ok, {:text, "pong"}, state}
  end

  #def handle_in({text, [opcode: :text]}, state) do
  #  {:reply, :ok, {:text, text}, state}
  #end

  def handle_in({%{"message" => message, op: 0}, [opcode: :text]}, state) do
    {:reply, :ok, {:text, message}, state}
  end

  def terminate(:timeout, state) do
    {:ok, state}
  end

  def terminate(:error, state) do
    Logger.warn("An Error ocurred...")
    {:ok, state}
  end
end
