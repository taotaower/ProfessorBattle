defmodule ProfbattleWeb.GamesChannel do
  use ProfbattleWeb, :channel

  alias Profbattle.Game

  def join("games:" <> name, payload, socket) do
    if authorized?(payload) do
      game = Profbattle.GameBackup.load(name)  || Game.new()
      socket = socket
               |> assign(:game, game)
               |> assign(:name, name)
      states = Profbattle.GameBackup.getStates()
      IO.inspect states

      {:ok, %{"join" => name, "game" => game}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("restart", payload, socket) do
    game = Game.new
    Profbattle.GameBackup.save(socket.assigns[:name], game)
    socket = assign(socket, :game, game)
    {:reply, {:ok, %{ "game" => game}}, socket}
  end

  def handle_in("click", %{"number" => n}, socket) do
    game = Game.click(socket.assigns[:game], n)
    Profbattle.GameBackup.save(socket.assigns[:name], game)
    socket = assign(socket, :game, game)
    {:reply, {:ok, %{ "game" =>  game}}, socket}
  end

  def handle_in("match", payload, socket) do
    game = Game.match(socket.assigns[:game])
    Profbattle.GameBackup.save(socket.assigns[:name], game)
    socket = assign(socket, :game, game)
    {:reply, {:ok, %{ "game" => game}}, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end