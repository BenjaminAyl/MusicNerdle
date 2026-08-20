defmodule MusicNerdle.Matches do
  @moduledoc """
  Public API for starting, looking up, and interacting with live matches.
  This is the facade `MusicNerdle.Lobby` and the web layer call through —
  neither should reach into `MatchServer`, `MatchSupervisor`, or `Registry`
  directly.

  ## Still to design
    * the public functions (e.g. `start_match/1`, `get_match/1`,
      `propose_connection/3`) - each should broadcast/1 whatever happened
      once it does
    * the message shapes broadcast below (e.g. `{:connection_proposed, ...}`,
      `{:match_ended, ...}`) so `MusicNerdleWeb.MatchLive`'s `handle_info/2`
      has something concrete to match on
    * how/when a `MusicNerdle.Matches.Match` record gets written once a
      match ends (per the "persist on completion" decision)

  ## Real-time wiring (already in place, no logic yet)

  `subscribe/1` and `broadcast/2` below are the only sanctioned way in or out
  of this match's topic - the web layer should never call `Phoenix.PubSub`
  directly, and `MatchServer` should call `broadcast/2` (not `PubSub`
  directly either) so the topic naming only lives in one place.
  """

  @pubsub MusicNerdle.PubSub

  @doc """
  Subscribes the calling process (typically a LiveView) to updates for the
  given match. Call from `mount/3`, guarded by `connected?(socket)`.
  """
  def subscribe(match_id) do
    Phoenix.PubSub.subscribe(@pubsub, topic(match_id))
  end

  @doc """
  Broadcasts a message to everyone subscribed to the given match. Intended
  to be called from inside `MusicNerdle.Matches.MatchServer`, not from the
  web layer.
  """
  def broadcast(match_id, message) do
    Phoenix.PubSub.broadcast(@pubsub, topic(match_id), message)
  end

  defp topic(match_id), do: "match:#{match_id}"
end
