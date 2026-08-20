defmodule MusicNerdleWeb.Presence do
  @moduledoc """
  Tracks who's actually still connected — separate from PubSub, which only
  tells you *what happened*, not *who's still here*. Backed by
  `Phoenix.Presence` (ships with the `phoenix` dep already, no extra
  package needed), which handles the join/leave diffing for you over the
  same `MusicNerdle.PubSub` server everything else uses.

  Likely uses:
    * lobby - show how many/who are waiting to be matched
    * a match - detect an opponent disconnecting/reconnecting mid-game

  ## Still to design
    * where `track/3` gets called (`LobbyLive`/`MatchLive` `mount/3`,
      guarded by `connected?(socket)`) and what metadata to track per
      player - needs `MusicNerdle.Accounts` (player identity) decided first
    * whether presence diffs are consumed directly (`handle_info(%{event:
      "presence_diff"}, ...)`) or wrapped through `Matches`/`Lobby` like the
      other broadcasts, so the web layer still only talks to context modules
  """

  use Phoenix.Presence,
    otp_app: :music_nerdle,
    pubsub_server: MusicNerdle.PubSub
end
