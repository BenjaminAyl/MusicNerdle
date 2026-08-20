defmodule MusicNerdle.Engine.Connection do
  @moduledoc """
  One proposed "link" between two albums (e.g. shared artist, producer,
  label, or genre) — the thing a player submits as their move.

  ## Still to design
    * the struct shape (which two albums, which shared attribute, who
      proposed it)
    * validation: what makes a connection legal? Exact producer credit only,
      or fuzzy/tag-based matches too?
    * how this relates to `MusicNerdle.Engine.Rules`, which presumably owns
      the actual validation logic
  """

  defstruct []
end
