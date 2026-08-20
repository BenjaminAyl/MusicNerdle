defmodule MusicNerdle.Lobby do
  @moduledoc """
  Public API for getting players from "wants to play" to "in a match".
  Wraps `MusicNerdle.Lobby.Queue` and, once players are paired, is expected
  to hand off to `MusicNerdle.Matches.start_match/1` to actually start the
  game.

  ## Still to design
    * the public functions (e.g. `join_queue/1`, `leave_queue/1`) - each
      should broadcast/1 whatever happened once it does
    * pure auto-matchmaking only, or also invite-a-friend rooms with a
      shareable code/link (that'd likely be a `MusicNerdle.Lobby.Room`
      alongside `Queue`, with its own topic/subscribe/broadcast)
    * the message shapes broadcast below (e.g. `{:queue_updated, ...}`,
      `{:match_found, match_id}`) so `MusicNerdleWeb.LobbyLive`'s
      `handle_info/2` has something concrete to match on
    * how players are identified while queued — see the open
      `MusicNerdle.Accounts` question, since Lobby needs *some* stable id
      per player

  ## Real-time wiring (already in place, no logic yet)

  `subscribe/0` and `broadcast/1` below are the only sanctioned way in or
  out of the lobby topic - `Queue` should call `broadcast/1` (not
  `Phoenix.PubSub` directly) so the topic naming only lives in one place.
  """

  @pubsub MusicNerdle.PubSub
  @topic "lobby"

  @doc """
  Subscribes the calling process (typically a LiveView) to lobby-wide
  updates. Call from `mount/3`, guarded by `connected?(socket)`.
  """
  def subscribe do
    Phoenix.PubSub.subscribe(@pubsub, @topic)
  end

  @doc """
  Broadcasts a message to everyone currently on the lobby screen. Intended
  to be called from inside `MusicNerdle.Lobby.Queue`, not the web layer.
  """
  def broadcast(message) do
    Phoenix.PubSub.broadcast(@pubsub, @topic, message)
  end
end
