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
      Map.get(state, name)
    end
  end

  def delete(name) do
    Agent.update __MODULE__, fn state ->
      Map.delete(state, name)
    end
  end

  def deleteOldStates() do
    today = DateTime.utc_now()
    Agent.get __MODULE__, fn state ->
      for  {k, v}  <-  state  do
        if (v.lastAction.day <= today.day && v.lastAction.hour + 2 < today.hour) do
          delete(k)
        end
      end
    end
  end

  def getStates() do
    deleteOldStates()
    Agent.get __MODULE__, fn set ->
      {Enum.into(set, [])}
    end
  end
end