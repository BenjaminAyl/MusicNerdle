defmodule MusicNerdleWeb.MatchLive do
  @moduledoc """
  The live game board for a single match. Expected to call
  `MusicNerdle.Matches.get_match/1` (or similar) on mount and render both
  players' progress as `MusicNerdle.Matches.MatchServer` broadcasts updates.

  ## Still to design
    * the board UI itself (album pair, path-so-far, connection input)
    * how a player's proposed connection gets submitted back to
      `MusicNerdle.Matches`
    * `handle_info/2` clauses for whatever `MusicNerdle.Matches.broadcast/2`
      sends (see the TODO in `MusicNerdle.Matches`'s moduledoc)
    * reconnect behavior - what a player sees if they refresh mid-match, and
      whether `MusicNerdleWeb.Presence` is used to detect the opponent
      dropping
  """

  use MusicNerdleWeb, :live_view

  alias MusicNerdle.Matches

  @impl true
  def mount(%{"id" => match_id}, _session, socket) do
    if connected?(socket) do
      Matches.subscribe(match_id)
      # TODO: MusicNerdleWeb.Presence.track/3 here once player identity is
      # designed, so a dropped opponent can be detected
    end

    {:ok, assign(socket, match_id: match_id)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <p>TODO: match UI</p>
    """
  end

  # Catch-all so an unhandled broadcast doesn't crash the LiveView - add
  # real clauses above this one as message shapes get designed.
  @impl true
  def handle_info(_message, socket) do
    {:noreply, socket}
  end
end
