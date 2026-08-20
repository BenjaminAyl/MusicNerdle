defmodule MusicNerdleWeb.LobbyLive do
  @moduledoc """
  Where a player lands to queue up for a match. Expected to call
  `MusicNerdle.Lobby.join_queue/1` on mount and redirect into
  `MusicNerdleWeb.MatchLive` once `MusicNerdle.Lobby.Queue` pairs them.

  ## Still to design
    * what this screen actually shows while waiting (queue position?
      estimated wait? a "create a room and invite a friend" option, if that
      open Lobby question gets a yes?)
    * `handle_info/2` clauses for whatever `MusicNerdle.Lobby.broadcast/1`
      sends (see the TODO in `MusicNerdle.Lobby`'s moduledoc)
    * whether to `MusicNerdleWeb.Presence.track/3` here once player identity
      exists, so the lobby can show who's actually waiting
  """

  use MusicNerdleWeb, :live_view

  alias MusicNerdle.Lobby

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Lobby.subscribe()
      # TODO: Lobby.join_queue(...) once player identity is designed
    end

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <p>TODO: lobby UI</p>
    """
  end

  # Catch-all so an unhandled broadcast doesn't crash the LiveView - add
  # real clauses above this one as message shapes get designed.
  @impl true
  def handle_info(_message, socket) do
    {:noreply, socket}
  end
end
