defmodule ProfbattleWeb.PageController do
  use ProfbattleWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
