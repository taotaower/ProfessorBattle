defmodule ProfbattleWeb.PageController do
  use ProfbattleWeb, :controller

  def index(conn, _params) do

    states = Profbattle.GameBackup.getStates()
             |> Tuple.to_list()
             |> List.first()
             |> Enum.map(fn(x) -> stateConvert(x) end)

    IO.inspect states

    render conn, "index.html",states: states
  end

  def game(conn, params) do
    render conn, "game.html", name: params["name"], player: params["player"]
  end

  defp stateConvert(state) do
    IO.inspect state
    state = Tuple.to_list(state)
    name = List.first(state)  # get name
    players = length(List.last(state)) # get number of players

    %{
    name: name,
    players: players
    }

  end
end
