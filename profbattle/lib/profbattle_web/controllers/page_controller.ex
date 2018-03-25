defmodule ProfbattleWeb.PageController do
  use ProfbattleWeb, :controller

  def index(conn, _params) do

    states = Profbattle.GameBackup.getStates()
             |> Tuple.to_list()
             |> List.first()
             |> Enum.map(fn(x) -> stateConvert(x) end)

    render conn, "index.html",states: states
  end

  def game(conn, params) do
    render conn, "game.html", name: params["name"], player: params["player"]
  end

  defp stateConvert(game) do

    state = Tuple.to_list(game)
    name = List.first(state)  # get name
    state = List.last(state) # get number of players

    %{
      name: name,
      state: state.gameState
    }

  end
end
