defmodule MusicNerdle.Engine.Game do
  @moduledoc """
  Pure, in-memory representation of a single game's state — the struct
  `MusicNerdle.Matches.MatchServer` holds and transitions as players play.

  No processes, no I/O, no persistence here on purpose. Keep it a plain
  struct + pure transition functions so it's trivially unit-testable in
  isolation from OTP/the web layer/the DB.

  ## Still to design
    * the struct's fields (start album, target album, path found so far,
      whose turn, time remaining, ...)
    * the transition functions (e.g. `propose_connection/3`, `winner/1`)
    * how this composes with `MusicNerdle.Engine.Rules` and
      `MusicNerdle.Engine.Connection`
  """

  defstruct []
end
