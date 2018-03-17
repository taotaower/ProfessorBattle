defmodule Profbattle.GameBackup do
  use Agent

  def start_link do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def save(name, game) do
    Agent.update __MODULE__, fn state ->
      Map.put(state, name, game)
    end
  end

  def load(name) do
    Agent.get __MODULE__, fn state ->
      #IO.inspect "test"
      Map.get(state, name)
    end
  end

  def getStates() do
    Agent.get __MODULE__, fn set ->
      {Enum.into(set, [])}
    end
  end
end