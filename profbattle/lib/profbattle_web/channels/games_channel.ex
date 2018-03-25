defmodule ProfbattleWeb.GamesChannel do
  use ProfbattleWeb, :channel

  alias Profbattle.Game

  def join("games:" <> name, payload, socket) do
    if authorized?(payload) do
      game = Profbattle.GameBackup.load(name)

      socket = socket
               |> assign(:game, game)
               |> assign(:name, name)

      if game do

        if game.gameState == 0 do
          game = Game.addPlayer(game)
        end

        else
        game = Game.new()
      end

      Profbattle.GameBackup.save(socket.assigns[:name], game)
      send(self, :after_join)
      {:ok, %{"join" => name, "game" => game}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_info(:after_join, socket) do
    name = socket.assigns[:name]
    game = Profbattle.GameBackup.load(name)
    broadcast! socket, "update", %{game: game}
    {:noreply, socket}
  end

  def handle_in("attack", %{"special" => special}, socket) do
    name = socket.assigns[:name]
    game = Profbattle.GameBackup.load(name)

    game = Game.attackAction(game,special)
    Profbattle.GameBackup.save(socket.assigns[:name], game)
    socket = assign(socket, :game, game)

    broadcast! socket, "update", %{game: game}
    {:noreply, socket}
  end

  # professor is array location
  def handle_in("swap", %{"professor" => p}, socket) do
    name = socket.assigns[:name]
    game = Profbattle.GameBackup.load(name)

    game = Game.swapAction(game, p)
    Profbattle.GameBackup.save(socket.assigns[:name], game)
    socket = assign(socket, :game, game)

    broadcast! socket, "update", %{game: game}
    {:noreply, socket}
  end


  def handle_in("coffee", %{}, socket) do
    name = socket.assigns[:name]
    game = Profbattle.GameBackup.load(name)

    game = Game.coffeeAction(game)
    Profbattle.GameBackup.save(socket.assigns[:name], game)
    socket = assign(socket, :game, game)

    broadcast! socket, "update", %{game: game}
    {:noreply, socket}
  end




  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end

  def handle_in("selectProf", %{"professor" => p}, socket) do
    name = socket.assigns[:name]
    game = Profbattle.GameBackup.load(name)

    game = Game.selectProf(game,p)
    Profbattle.GameBackup.save(socket.assigns[:name], game)
    socket = socket
             |> assign(:game, game)

    broadcast! socket, "update", %{game: game}
    {:noreply, socket}
  end

  def handle_in("close", %{"professor" => p}, socket) do

      IO.inspect "closeeeeeee"

  end

end
