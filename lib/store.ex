defmodule Pkm.Store do
  @moduledoc """
  This is what's responsible for storing information about User's keys.
  """
  use Agent

  def start_link(_) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  @spec push(String.t(), String.t()) :: String.t()
  def push(name, key) do
    Agent.get(__MODULE__, &(&1) |> Map.put(name, key))
  end

  @spec get(String.t()) :: String.t() | nil
  def get(name) do
    Agent.get(__MODULE__, &(&1) |> Map.get(name))
  end
end
