defmodule MusicNerdle.Accounts do
  @moduledoc """
  Player identity. Deliberately left undesigned — this is an open decision,
  not an oversight.

  ## Open question
    * anonymous, session-based players (simplest — a display name + a
      LiveView session id, no auth) vs real accounts (needed if you want
      persistent history/leaderboards tied to a person across devices/games)

  Whichever you pick, both `MusicNerdle.Lobby` and `MusicNerdle.Matches.Match`
  need *some* stable player identifier, so this is worth deciding before
  those take real shape.
  """
end
