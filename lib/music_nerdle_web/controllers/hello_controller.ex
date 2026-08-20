defmodule MusicNerdleWeb.HelloController do
  use MusicNerdleWeb, :controller

  def show(conn, %{"messenger" => messenger}) do
    render(conn, :show, messenger: messenger)
  end
end
