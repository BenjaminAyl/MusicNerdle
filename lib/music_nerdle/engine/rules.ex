defmodule MusicNerdle.Engine.Rules do
  @moduledoc """
  The actual rule set: what counts as a valid connection between two albums,
  scoring, win conditions, turn/time limits, etc.

  Kept separate from `MusicNerdle.Engine.Game` (state) and
  `MusicNerdle.Engine.Connection` (a single proposed link) so the rules
  themselves stay easy to find, test, and tune independently of state
  management.

  ## Still to design
    * everything — this is the heart of the game and entirely undesigned
  """
end
