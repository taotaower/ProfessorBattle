defmodule ProfbattleWeb.GamesChannel do
  use ProfbattleWeb, :channel

  alias Profbattle.Game

  def join("games:" <> name, payload, socket) do
    if authorized?(payload) do
      game = Profbattle.GameBackup.load(name)

      IO.inspect "join a game condition"
      IO.inspect game

      if game do

        if length(game) == 1 do
          game = Game.addPlayer(game)
        end

        else
        game = Game.new()
      end
      socket = socket
               |> assign(:game, game)
               |> assign(:name, name)


      Profbattle.GameBackup.save(socket.assigns[:name], game)

      {:ok, %{"join" => name, "game" => game}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("select", %{"professor" => p}, socket) do
    game = Game.select(socket.assigns[:game], p)
    Profbattle.GameBackup.save(socket.assigns[:name], game)
    socket = assign(socket, :game, game)
    {:reply, {:ok, %{ "game" => game}}, socket}
  end

  def handle_in("attack", %{"player" => n}, socket) do
    game = Game.attack(socket.assigns[:game], n)
    Profbattle.GameBackup.save(socket.assigns[:name], game)
    socket = assign(socket, :game, game)
    {:reply, {:ok, %{ "game" =>  game}}, socket}
  end

  # professor is array location
  def handle_in("swap", %{"player" => n, "professor" => p}, socket) do
    game = Game.swap(socket.assigns[:game], n, p)
    Profbattle.GameBackup.save(socket.assigns[:name], game)
    socket = assign(socket, :game, game)
    {:reply, {:ok, %{ "game" => game}}, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
