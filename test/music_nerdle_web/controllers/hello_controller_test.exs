defmodule MusicNerdleWeb.HelloControllerTest do
  use MusicNerdleWeb.ConnCase

  @moduledoc """
  This is an end-to-end test: `ConnCase` boots the real `MusicNerdleWeb.Endpoint`,
  so `get/2` below sends an actual HTTP request through the endpoint's plug
  pipeline, into the router, through the `:browser` pipeline, into
  `HelloController.show/2`, and back out through `HelloHTML`'s template.
  Nothing here is mocked or called directly — we only assert on the response
  that comes out the other end, exactly like a browser or client would see it.
  """

  test "GET /hello/:messenger renders a greeting", %{conn: conn} do
    conn = get(conn, ~p"/hello/world")

    assert html_response(conn, 200) =~ "Hello, world, from world!"
  end

  test "GET /hello/:messenger echoes back whatever messenger is given", %{conn: conn} do
    conn = get(conn, ~p"/hello/Ben")

    assert html_response(conn, 200) =~ "Hello, world, from Ben!"
  end
end
