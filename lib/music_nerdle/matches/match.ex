defmodule MusicNerdle.Matches.Match do
  @moduledoc """
  Persisted record of a completed match, written once a `MatchServer`
  finishes (per the "in-memory during play, persisted on completion"
  decision) so history/stats/leaderboards survive process/node restarts.

  ## Still to design
    * fields — likely players, winner, the starting album pair, the path
      found, started_at/ended_at
    * whether individual moves get persisted too (e.g. a separate
      `match_events`/`match_moves` table) for replay/anti-cheat, or just
      the final result
    * once fields are decided: `mix ecto.gen.migration create_matches`
  """

  use Ecto.Schema

  schema "matches" do
    # TODO: define fields once the shape above is decided
    timestamps()
  end
end
