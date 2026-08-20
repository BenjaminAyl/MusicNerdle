defmodule MusicNerdleWeb.PageController do
  use MusicNerdleWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
